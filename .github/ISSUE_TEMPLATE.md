If Homebrew was updated on Aug 10-11th 2016 and `brew update` always says `Already up-to-date.` you need to run: `cd "$(brew --repo)" && git fetch && git reset --hard origin/master && brew update`.

# Please follow the general troubleshooting steps first:

- [ ] Ran `brew update` and retried your prior step?
- [ ] Ran `brew doctor`, fixed as many issues as possible and retried your prior step?
- [ ] Confirmed this is a problem with specific formulae and not Homebrew/brew? If it's a general Homebrew/brew problem please file this issue at https://github.com/Homebrew/brew/issues/new

_You can erase any parts of this template not applicable to your Issue._

### Bug reports:

Please replace this section with a brief summary of your issue **AND** the output of `brew config` and `brew doctor` or if reporting a formula issue include the link from:
`brew gist-logs <formula>`
(where `<formula>` is the name of the formula that failed to build). Please note we may immediately close your issue without comment if you do not fill out the issue template and provide the requested information.

### Formula Requests:

**Please note by far the quickest way to get a new formula into Homebrew is to file a [Pull Request](https://github.com/Homebrew/homebrew-core/blob/master/CONTRIBUTING.md).**

Please replace this section with the homepage and name of your requested formula (after using `brew search` to check it does not already exist). Please note we may close this issue or ask you to create a pull-request if it's something we're not actively planning to work on.
