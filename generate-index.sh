#!/bin/bash

# Generate index.html with links to all other HTML files in a table sorted by date
cd "$(dirname "$0")"

cat > index.html << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HTML Toys</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            padding: 2rem;
            color: #e0e0e0;
        }
        h1 {
            text-align: center;
            margin-bottom: 2rem;
            color: #fff;
            font-size: 2.5rem;
            text-shadow: 0 0 20px rgba(255,255,255,0.3);
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255,255,255,0.05);
            border-radius: 12px;
            overflow: hidden;
        }
        th {
            background: rgba(255,255,255,0.1);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #fff;
        }
        td {
            padding: 1rem;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        tr:hover td {
            background: rgba(255,255,255,0.05);
        }
        a {
            color: #64b5f6;
            text-decoration: none;
        }
        a:hover {
            color: #90caf9;
            text-decoration: underline;
        }
        .date {
            color: #888;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>HTML Toys</h1>
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Last Modified</th>
                </tr>
            </thead>
            <tbody>
HEADER

# Get files with modification times, sort by date (newest first), and generate table rows
for file in *.html; do
    if [ "$file" != "index.html" ]; then
        # Get modification timestamp for sorting and display date
        mod_time=$(stat -f "%m" "$file")
        mod_date=$(stat -f "%Sm" -t "%b %d, %Y %H:%M" "$file")
        echo "$mod_time|$file|$mod_date"
    fi
done | sort -rn -t'|' -k1 | while IFS='|' read -r timestamp file date; do
    display_name=$(echo "$file" | sed 's/\.html$//')
    echo "            <tr><td><a href=\"$file\">$display_name</a></td><td class=\"date\">$date</td></tr>" >> index.html
done

cat >> index.html << 'FOOTER'
            </tbody>
        </table>
    </div>
</body>
</html>
FOOTER

echo "index.html generated successfully!"
