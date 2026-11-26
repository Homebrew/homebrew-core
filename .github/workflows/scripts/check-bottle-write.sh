#!/bin/bash
set -euo pipefail

# Use the same package names as GitHubPackages.image_formula_name.
packages="$(jq -ers 'map(.[] | .formula.name | gsub("@"; "/") | gsub("[+]"; "x")) | unique[]' "$@")"
while IFS= read -r package; do
  head -c 32 /dev/urandom > "$RUNNER_TEMP/bottle-write-probe"
  oras blob push --username "$HOMEBREW_GITHUB_PACKAGES_USER" --password-stdin \
    "ghcr.io/homebrew/core/$package" "$RUNNER_TEMP/bottle-write-probe" <<< "$HOMEBREW_GITHUB_PACKAGES_TOKEN"
done <<< "$packages"
