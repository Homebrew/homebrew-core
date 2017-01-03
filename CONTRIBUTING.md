# Contributing to Homebrew

First time contributing to Homebrew? Read our [Code of Conduct](https://github.com/Homebrew/brew/blob/master/CODEOFCONDUCT.md#code-of-conduct).

### Report a bug

* run `brew update` (twice)
* run and read `brew doctor`
* read [the Troubleshooting Checklist](https://github.com/Homebrew/brew/blob/master/docs/Troubleshooting.md#troubleshooting)
* open an issue on the formula's repository

### Submit a version upgrade for the `foo` formula

* check if the same upgrade has been already submitted by [searching the open pull requests for `foo`](https://github.com/Homebrew/homebrew-core/pulls?utf8=✓&q=is%3Apr+is%3Aopen+foo).
* `brew bump-formula-pr --strict foo` with `--url=...` and `--sha256=...` or `--tag=...` and `--revision=...` arguments.

### Add a new formula for `foo` version `2.3.4` from `$URL`

* read [the Formula Cookbook](https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md#formula-cookbook) or: `brew create $URL` and make edits
* `brew install --build-from-source foo`
* `brew audit --new-formula foo`
* `git commit` with message formatted `foo 2.3.4 (new formula)`
* [open a pull request](https://github.com/Homebrew/brew/blob/master/docs/How-To-Open-a-Homebrew-Pull-Request-(and-get-it-merged).md#how-to-open-a-homebrew-pull-request-and-get-it-merged) and fix any failing tests

### Contribute a fix to the `foo` formula

* `brew edit foo` and make edits
* leave the [`bottle`](http://www.rubydoc.info/github/Homebrew/brew/master/Formula#bottle-class_method) as-is
* `brew uninstall --force foo`, `brew install --build-from-source foo`, `brew test foo`, and `brew audit --strict foo`
* `git commit` with message formatted `foo: fix <insert details>`
* [open a pull request](https://github.com/Homebrew/brew/blob/master/docs/How-To-Open-a-Homebrew-Pull-Request-(and-get-it-merged).md#how-to-open-a-homebrew-pull-request-and-get-it-merged) and fix any failing tests

Thanks!
