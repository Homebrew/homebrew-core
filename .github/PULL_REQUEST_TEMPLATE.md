<<<<<<< HEAD
<!--

Please ensure your commit message uses the correct format:

# When adding a new formula
The commit message should be `<formula> <version> (new formula)`

# Using `brew bump-formula-pr` to bump a version of a formula is highly recommended as it does everything for you.
If that command doesn't work or you choose to do the version bump manually:
The commit message should be `<formula> <version>`

# For submitting a new patch for the formula
The commit message should be `<formula>: short-description-for-the-change`

 -->

- [ ] Have you followed the [guidelines for contributing](https://github.com/Homebrew/homebrew-core/blob/master/CONTRIBUTING.md)?
=======
- [ ] Have you followed the [guidelines for contributing](https://github.com/Homebrew/homebrew-core/blob/HEAD/CONTRIBUTING.md)?
>>>>>>> upstream/master
- [ ] Have you checked that there aren't other open [pull requests](https://github.com/Homebrew/homebrew-core/pulls) for the same formula update/change?
- [ ] Have you built your formula locally with `brew install --build-from-source <formula>`, where `<formula>` is the name of the formula you're submitting?
- [ ] Is your test running fine `brew test <formula>`, where `<formula>` is the name of the formula you're submitting?
- [ ] Does your build pass `brew audit --strict <formula>` (after doing `brew install <formula>`)?

-----
