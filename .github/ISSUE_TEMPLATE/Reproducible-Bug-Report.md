---
name: Reproducible Bug Report
about: "If you're sure it's reproducible and not just your machine: submit an issue so we can investigate."

---

**Please note we will close your issue without comment if you delete, do not read or do not fill out the issue checklist below and provide ALL the requested information. If you repeatedly fail to use the issue template, we will block you from ever submitting issues to Homebrew again.**

- [ ] ran `brew update` and can still reproduce the problem?
- [ ] ran `brew doctor`, fixed all issues and can still reproduce the problem?
- [ ] ran `brew gist-logs <formula>` (where `<formula>` is the name of the formula that failed) and included the output link?
- [ ] if `brew gist-logs` didn't work: ran `brew config` and `brew doctor` and included their output with your issue?

To help us debug your issue please explain:

- What you were trying to do (and why)
- What happened (include command output)
- What you expected to happen
- Step-by-step reproduction instructions (by running `brew install` commands)
