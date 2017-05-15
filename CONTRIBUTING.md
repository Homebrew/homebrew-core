# Contributing to Homebrew

First time contributing to Homebrew? Read our [Code of Conduct](https://github.com/Homebrew/brew/blob/master/CODEOFCONDUCT.md#code-of-conduct).

### Report a bug

* run `brew update` (twice)
* run and read `brew doctor`
* read [the Troubleshooting Checklist](http://docs.brew.sh/Troubleshooting.html)
* open an issue on the formula's repository

### Submit a version upgrade for the `foo` formula

* check if the same upgrade has been already submitted by [searching the open pull requests for `foo`](https://github.com/Homebrew/homebrew-core/pulls?utf8=✓&q=is%3Apr+is%3Aopen+foo).
* `brew bump-formula-pr --strict foo` with `--url=...` and `--sha256=...` or `--tag=...` and `--revision=...` arguments.

### Add a new formula for `foo` version `2.3.4` from `$URL`

* read [the Formula Cookbook](http://docs.brew.sh/Formula-Cookbook.html) or: `brew create $URL` and make edits
* `brew install --build-from-source foo`
* `brew audit --new-formula foo`
* `git commit` with message formatted `foo 2.3.4 (new formula)`
* [open a pull request](http://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request.html) and fix any failing tests

### Contribute a fix to the `foo` formula

* `brew edit foo` and make edits
* leave the [`bottle`](http://www.rubydoc.info/github/Homebrew/brew/master/Formula#bottle-class_method) as-is
* `brew uninstall --force foo`, `brew install --build-from-source foo`, `brew test foo`, and `brew audit --strict foo`
* `git commit` with message formatted `foo: fix <insert details>`
* [open a pull request](http://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request.html) and fix any failing tests

Thanks!

### P.S. What about Linux specific changes?

While it's much easier to make the package manager cross-platform without harming readability. Ideally we'll end up at a point where Linuxbrew can run an unpatched Homebrew/brew. This will never happen on homebrew-core without a cross-platform formula abstraction layer which will need to break backwards compatibility which we will never do. Linuxbrew should create their own homebrew-core (not a fork) and maintain formulae known to work on Linux configured how best makes sense on Linux.
