#!/bin/bash
set -e

rsync -a --delete --exclude .git --exclude .gitignore ../main/repo/ .
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git config --global user.name "github-actions[bot]"
git status
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Update extensions repo"
    git push

    # Purge cached index on jsDelivr
    # TODO: i don't know if this will work as-is, or if jsdelivr needs to be configured first...
    curl https://purge.jsdelivr.net/gh/tachiyomi-extensions-org/tachiyomi-extensions@repo/index.min.json
else
    echo "No changes to commit"
fi
