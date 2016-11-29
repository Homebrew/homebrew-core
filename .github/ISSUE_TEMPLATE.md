If Homebrew was updated on Aug 10-11th 2016 and `brew update` always says `Already up-to-date.` you need to run: `cd "$(brew --repo)" && git fetch && git reset --hard origin/master && brew update`.

# Please follow the general troubleshooting steps first:

- [ ] Ran `brew update` and retried your prior step?
- [ ] Ran `brew doctor`, fixed as many issues as possible and retried your prior step?
- [ ] If you're seeing permission errors tried running `sudo chown -R $(whoami) $(brew --prefix)`?

_You can erase any parts of this template not applicable to your Issue._

### Bug reports:

Please replace this section with a summary of your issue. Always include **exact commands that resulted in errors**, **exact error messages**, and ideally full transcripts of such commands.

 If reporting a build issue, please also include the link from:

`brew gist-logs <formula>`
(where `<formula>` is the name of the formula that failed to build).

### Formula Requests:

**Please note by far the quickest way to get a new formula into Homebrew is to file a [Pull Request](https://github.com/Homebrew/homebrew-core/blob/master/CONTRIBUTING.md).**

We will consider your request but it may be closed if it's something we're not actively planning to work on.
