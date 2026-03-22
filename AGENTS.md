# Agent Instructions for homebrew-core

This document helps coding agents produce high-quality PRs for homebrew-core formula contributions.

## Before Any PR

1. **Check for existing PRs** for the same formula: [open PRs](https://github.com/Homebrew/homebrew-core/pulls)
2. Run `brew tap homebrew/core` if not already tapped

## Version Updates

Preferred method for version bumps:

```sh
brew bump-formula-pr --strict <formula> --url=<url> --sha256=<sha256>
# or
brew bump-formula-pr --strict <formula> --tag=<tag> --revision=<revision>
# or
brew bump-formula-pr --strict <formula> --version=<version>
```

This handles URL/checksum updates, commit message, and opens the PR automatically.

### Manual Version Updates

If manual editing is needed:

```sh
brew edit <formula>
# Update url and sha256 (or tag and revision)
# Leave `bottle do` block unchanged
```

Commit message: `foo 1.2.3`

## Formula Fixes

For bug fixes or improvements to existing formulae:

```sh
brew edit <formula>
# Make changes
# Leave `bottle do` block unchanged
```

Commit message: `foo: fix <description>` or `foo: <description>`

### When to Add a Revision

Add or increment `revision` when:
- Fix requires existing bottles to be rebuilt
- Dependencies changed in a way that affects the built package
- The installed binary/library behavior changes

Do NOT add revision for cosmetic changes (comments, style, livecheck fixes).

## New Formulae

```sh
brew create <url>
# Edit the generated formula
```

Commit message: `foo 1.2.3 (new formula)`

### Required Elements

- **Test block**: MUST verify actual functionality, not just `--version` or `--help`
  - Version check is acceptable as an additional assertion
  - For libraries: compile and link sample code
  - Use `testpath` for temporary files

- **Service block**: If the software can run as a daemon, include a `service do` block:
  ```ruby
service do
  run [opt_bin/"foo", "start"]
  keep_alive true
end
  ```

- **Livecheck**: Prefer default behavior. Only add a `livecheck` block if automatic detection fails.

- **Head support**: Include when the project has a development branch:
  ```ruby
head "https://github.com/org/repo.git", branch: "main"
  ```
  Git repositories MUST specify `branch:`.

## Required Validation (All PR Types)

All checks MUST pass locally before opening a PR:

```sh
# Build from source (required)
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source <formula>

# Run tests
brew test <formula>

# Audit (existing formula)
brew audit --strict <formula>

# Audit (new formula only)
brew audit --new <formula>

# Style check
brew style <formula>
```

## PR Template Checklist

You MUST verify all items before submitting:

- [ ] Followed [CONTRIBUTING.md](CONTRIBUTING.md)
- [ ] Commits follow [commit style guide](https://docs.brew.sh/Formula-Cookbook#commit)
- [ ] No existing [open PRs](https://github.com/Homebrew/homebrew-core/pulls) for same change
- [ ] Built locally with `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source`
- [ ] Tests pass with `brew test`
- [ ] Audit passes with `brew audit --strict` (or `--new` for new formulae)

## Commit Message Format

- Version update: `foo 1.2.3`
- New formula: `foo 1.2.3 (new formula)`
- Fix/change: `foo: fix <description>` or `foo: <description>`
- First line MUST be 50 characters or less
- Reference issues with `Closes #12345` in commit body if applicable

## PR Hygiene

### MUST

- One formula change per PR
- Keep diffs minimal and focused
- Provide only essential context in PR description

### MUST NOT

- Edit `bottle do` blocks (managed by BrewTestBot)
- Batch unrelated formula changes
- Include large logs or verbose output in PR body
- Add non-Homebrew usage caveats in PR body
- Include unrelated refactors or cleanups

## PR Description Template

Keep it minimal:

```
Built and tested locally on [macOS version/Linux].

[One sentence describing the change if not obvious from title.]
```

## CI Failures

- Reproduce failures locally before debugging
- Read error messages and annotations in "Files changed" tab
- Check complete build log in "Checks" tab if needed
- For Linux failures, use the [Homebrew Docker container](CONTRIBUTING.md#homebrew-docker-container)
- If stuck, comment describing what you've tried

## AI Disclosure

If AI assisted with the PR, check the AI checkbox in the PR template and briefly describe:
- How AI was used
- What manual verification was performed

## References

- [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [How to Open a PR](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request)
