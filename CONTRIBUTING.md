# Contributing to Homebrew

First time contributing to Homebrew? Read our [Code of Conduct](https://github.com/Homebrew/.github/blob/HEAD/CODE_OF_CONDUCT.md#code-of-conduct).

Ensure your commits follow the [commit style guide](https://docs.brew.sh/Formula-Cookbook#commit).

Thanks for contributing!

### To report a bug

* run `brew update` (twice)
* run and read `brew doctor`
* read [the Troubleshooting Checklist](https://docs.brew.sh/Troubleshooting)
* open an issue on the formula's repository

### To submit a version upgrade for the `foo` formula

* check if the same upgrade has been already submitted by [searching the open pull requests for `foo`](https://github.com/Homebrew/homebrew-core/pulls?utf8=✓&q=is%3Apr+is%3Aopen+foo).
* `brew bump-formula-pr --strict foo` with one of the following:
  * `--url=...` and `--sha256=...`
  * `--tag=...` and `--revision=...`
  * `--version=...`

### To add a new formula for `foo` version `2.3.4` from `$URL`

* read [the Formula Cookbook](https://docs.brew.sh/Formula-Cookbook) or: `brew create $URL` and make edits
* `brew install --build-from-source foo`
* `brew audit --new-formula foo`
* `git commit` with message formatted `foo 2.3.4 (new formula)`
* [open a pull request](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request) and fix any failing tests

Once you've addressed any potential feedback and a member of the Homebrew org has approved your pull request, the [BrewTestBot](https://github.com/BrewTestBot) will automatically merge it a couple of minutes later.

### To contribute a fix to the `foo` formula

If you are already well versed in the use of `git`, then you can find the local
copy of the `homebrew-core` repository in this directory:
`$(brew --repository homebrew/core)`. Modify the formula there using `brew edit foo`
leaving the section `bottle do ... end` unchanged, and prepare a pull request
as you usually do.  Before submitting your pull request, be sure to test it
with these commands:

```
brew uninstall --force foo
brew install --build-from-source foo
brew test foo
brew audit --strict foo
brew style foo
```

After testing, if you think it is needed to force the corresponding bottles to be
rebuilt and redistributed, add a line of the form `revision 1` to the formula,
or add 1 to the revision number already present.

If you are not already well versed in the use of `git`, then you may learn
about it from the introduction at
https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request and then proceed as
follows:

* run `brew edit foo` and make edits
* leave the section `bottle do ... end` unchanged
* test your changes using the commands listed above
* run `git commit` with message formatted `foo <insert new version number>` or `foo: <insert details>`
* open a pull request as described in the introduction linked to above, wait for the automated test results, and fix any failing tests

Once you've addressed any potential feedback and a member of the Homebrew org has approved your pull request, the [BrewTestBot](https://github.com/BrewTestBot) will automatically merge it a couple of minutes later.

### Dealing with CI failures

Pull requests with failing CI should not be merged, so the failures will need to be fixed. Start by looking for errors in the CI log. Some errors will show up as annotations in the "Files changed" tab of your pull request. If there are no annotations, or the annotations do not contain the relevant errors, then the complete build log can be found in the "Checks" tab of your pull request.

Once you've identified the error(s), check whether you can reproduce them locally. You should be able to do this with one or more of `brew install --build-from-source`, `brew audit --strict --online`, and `brew test`. Don't forget to checkout your PR branch before trying this! If you can reproduce the failure(s), then it is likely that the formula needs to be fixed. Read the error messages carefully. Many errors provide hints on how to fix them. Failing that: looking up the error message is often a fruitful source of hints for what to do next.

If you can't reproduce an error, then you need to identify what makes your local environment different from the build environment in CI. It is likely that one of those differences is driving the CI failure. It may help to try to make your local environment as similar to CI as possible to try to reproduce the failure. If the CI failure occurs on Linux, you can use the Homebrew Docker container to emulate the CI environment. See the next section for a guide on how to do this.

If you're still stuck: don't fret. Leave a comment on your PR describing what you've done to try to diagnose and fix the CI failure and we'll do our best to help you resolve them.

### Homebrew Docker container

Linux CI runs on a Docker container running Ubuntu 16.04. If you have Docker installed, you can use our container with:

```
docker run --interactive --tty --rm --pull always homebrew/ubuntu16.04:latest /bin/bash
```

If you don't have Docker installed:

```
brew install --formula docker lima
limactl start template://docker
docker context create lima --docker "host=unix://${HOME}/.lima/docker/sock/docker.sock"
docker context use lima
```

You should now be able to run the `docker` command shown above.
