---
last_review_date: "1970-01-01"
---

# Acceptable Formulae

Some formulae should not go in [homebrew/core](https://github.com/Homebrew/homebrew-core). But there are additional [Interesting Taps and Forks](Interesting-Taps-and-Forks.md) and anyone can [start their own](How-to-Create-and-Maintain-a-Tap.md)!

* Table of Contents
{:toc}

## Requirements for `homebrew/core`

### Supported platforms

The formula needs to build and pass tests on the latest 3 supported macOS versions ([Apple Silicon and x86_64](Installation.md#macos-requirements)) and on x86_64 [Linux](Linux-CI.md). Please have a look at the continuous integration jobs on a pull request in `homebrew/core` to see the full list of OSs. If upstream does not support one of these platforms, an exception can be made and the formula can be disabled for that platform.

### Duplicates of system packages

We now accept stuff that comes with macOS as long as it uses `keg_only :provided_by_macos` to be keg-only by default.

### Versioned formulae

We now accept versioned formulae as long as they [meet the requirements](Versions.md).

### Not a fork (usually)

We will not add new formulae using forks unless at least one of the following is true:

* the fork has been designated the official successor in the original source repository (e.g. in the README) or in a publicly verifiable way by the original author (e.g. in an issue or pull request comment)
* the fork has been used as the replacement by at least two other major distributions (e.g. Debian, Fedora, Arch, Gentoo, not smaller Linux distributions that are not widely used)

The fork must still meet all the other acceptable formulae requirements (including those of e.g. popularity and self-submission).

An alternative to the fork replacing the original formula is a new formula. For example, if `MikeMcQuaid` forked `curl` and it was very popular: a `curl-mikemcquaid` formula might make sense.

### We don’t like tools that upgrade themselves

Software that can upgrade itself does not integrate well with Homebrew formulae's own upgrade functionality. The self-update functionality should be disabled (while minimising complication to the formula). It's fine (and well-supported) for Casks.

### We don’t like install scripts that download unversioned things

We don't like install scripts that are pulling from the default branch of Git repositories or unversioned, unchecksummed tarballs. These should ideally use `resource` blocks with specific revisions or checksummed tarballs instead. Note that we now allow tools like `cargo`, `gem` and `pip` to download versioned libraries during installation. There's no need to reproduce the functionality of any language package manager with `resource` blocks when we can call it instead.

### We don’t like binary formulae

Our policy is that formulae in the core tap ([homebrew/core](https://github.com/Homebrew/homebrew-core)) must be open-source with a [Debian Free Software Guidelines license](https://wiki.debian.org/DFSGLicenses) and either built from source or producing cross-platform binaries (e.g. Java, Mono). Binary-only formulae should go in [homebrew/cask](https://github.com/Homebrew/homebrew-cask).

Additionally, core formulae must also not depend on casks or any other proprietary software. This includes automatic installation of casks at runtime.

### Stable versions

Formulae in the core repository must have a stable version tagged by the upstream project. Tarballs are preferred to Git checkouts, and tarballs should include the version in the filename whenever possible.

We don’t accept software without a tagged version because they regularly break due to upstream changes and we can’t provide [bottles](Bottles.md) for them.

### Niche (or self-submitted) stuff

The software in question must:

* be maintained (i.e. the last release wasn't ages ago, it works without patching on all Homebrew-supported OS versions and has no outstanding, unpatched security vulnerabilities)
* be stable (e.g. not declared "unstable" or "beta" by upstream)
* be known (e.g. GitHub repositories should have >=30 forks, >=30 watchers or >=75 stars)
* be used
* have a homepage

We will reject formulae that seem too obscure, partly because they won’t get maintained and partly because we have to draw the line somewhere.

We frown on authors submitting their own work unless it is very popular.

Don’t forget Homebrew is all Git underneath! [Maintain your own tap](How-to-Create-and-Maintain-a-Tap.md) if you have to!

There may be exceptions to these rules in the main repository; we may include things that don't meet these criteria or reject things that do. Please trust that we need to use our discretion based on our experience running a package manager.

### Stuff that builds an `.app`

Don’t make your formula build an `.app` (native macOS Application); we don’t want those things in Homebrew. Encourage upstream projects to build and support a `.app` that can be distributed by [homebrew/cask](https://github.com/Homebrew/homebrew-cask) (and used without it, too).

### Stuff that builds a GUI by default (but doesn't have to)

Make it build a command-line tool or a library by default and, if the GUI is useful and would be widely used, also build the GUI. Don’t build X11/XQuartz GUIs as they are a bad user experience on macOS.

### Stuff that doesn't build with the latest, stable Xcode Clang

Clang is the default C/C++ compiler on macOS (and has been for a long time). Software that doesn't build with it hasn't been adequately ported to macOS.

### Stuff that requires heavy manual pre/post-install intervention

We're a package manager so we want to do things like resolve dependencies and set up applications for our users. If things require too much manual intervention then they aren't useful in a package manager.

### Shared vs. static libraries

In general, if formulae have to ship either shared or static libraries: they should ship shared ones.
If there is interest in static libraries they can ship both.
Shipping only static libraries should be avoided when possible, particularly when the formula is depended on by other formulae since these dependents cannot be updated without a rebuild.

### Stuff that requires vendored versions of Homebrew formulae

Homebrew formulae should avoid having multiple, separate, upstream projects bundled together in a single package to avoid shipping outdated/insecure versions of software that is already a formula. Veracode's [State of Software Security report](https://www.veracode.com/blog/research/announcing-state-software-security-v11-open-source-edition) concludes:
> In fact, 79% of the time, developers never update third-party libraries after including them in a codebase.

For more info see [Debian's](https://www.debian.org/doc/debian-policy/ch-source.html#s-embeddedfiles) and [Fedora's](https://docs.fedoraproject.org/en-US/packaging-guidelines/#bundling) stances on this.

Increasingly, though: this can be (too) hard. Homebrew's primary mission is to be useful rather than ideologically pure. If we cannot package something without using vendored upstream versions: so be it; better to have packaged software in Homebrew than not.

### Adult Content

Homebrew is a tool where the vast majority of users are adults.
We have users all over the world with different views on sex, violence, etc.
As a result, we do not see it as our role to enforce any particular culture's views on adult content onto our users.
That said, we want to ensure our maintainers don't have to interact with adult content unless they choose to.

We will accept formulae with adult content but require the `homepage` and root of the `url` domain to be "safe for work" e.g. not display any images of violence or adult content.
It is acceptable for these pages to have textual descriptions of adult content.

Homebrew reserves the right to add or remove formulae based on how it affects the wider Homebrew ecosystem.
For a hypothetical example, if a critical infrastructure host said we needed to remove the formula to maintain our infrastructure: we may begrudgingly remove it to maintain continuity for our users.

## Sometimes there are exceptions

Even if all criteria are met we may not accept the formula. Even if some criteria are not met we may accept the formula. New formulae are held to a higher standard than existing formulae. Documentation will lag behind current decision-making. Although some rejections may seem arbitrary or strange they are based on years of experience making Homebrew work acceptably for our users.
---
last_review_date: 2025-05-15
---

# Deprecating, Disabling and Removing Formulae

There are many reasons why formulae may be deprecated, disabled or removed. This document explains the differences between each method as well as explaining when one method should be used over another.

## Overview

These general rules of thumb can be followed:

1. `deprecate!` should be used for formulae that _should_ no longer be used.
2. `disable!` should be used for formulae that _cannot_ be used.
3. Formulae that are no longer acceptable in `homebrew/core` or have been disabled for over a year _should_ be removed.

## Deprecation

If a user attempts to install a deprecated formula, they will be shown a warning message but the install will proceed.

A formula should be deprecated to indicate to users that the formula should not be used and will be disabled in the future. Deprecated formulae should continue to be maintained by the Homebrew maintainers so they still build from source and their bottles continue to work (even if unmaintained upstream). If this is not possible, they should be disabled.

The most common reasons for deprecation are when the upstream project is deprecated, unmaintained or archived.

Formulae should only be deprecated if at least one of the following are true:

- the formula does not build on any supported OS versions
- the software installed by the formula has outstanding CVEs
- the software installed by the formula has been discontinued or abandoned upstream
- the formula has [zero installs in the last 90 days](https://formulae.brew.sh/analytics/install/90d/)

Formulae with dependents should not be deprecated unless all dependents are also deprecated.

To deprecate a formula, add a `deprecate!` call. This call should include a deprecation date in the ISO 8601 format and a deprecation reason:

```ruby
deprecate! date: "YYYY-MM-DD", because: :reason
```

The `date` parameter should be set to the date that the deprecation period should begin, which is usually today's date. If the `date` parameter is set to a date in the future, the formula will not become deprecated until that date. This can be useful if the upstream developers have indicated a date when the project or version will stop being supported. Do not backdate the `date` parameter as it causes confusion for users and maintainers.

The `because` parameter can be a preset reason (using a symbol) or a custom reason. See the [Deprecate and Disable Reasons](#deprecate-and-disable-reasons) section below for more details about the `because` parameter.

An optional `replacement_formula` or `replacement_cask` parameter may also be specified to suggest a replacement formula or cask to the user. The value for the parameter is a string.

```ruby
deprecate! date: "YYYY-MM-DD", because: :reason, replacement_formula: "foo"
```

## Disabling

If a user attempts to install a disabled formula, they will be shown an error message and the install will fail.

A formula should be disabled to indicate to users that the formula cannot be used and will be removed in the future. Disabled formulae may no longer build from source or have working bottles.

The most common reasons for disabling a formula are:

- it cannot be built from source on any supported OS versions (meaning no new bottles can be built)
- it has been deprecated for a long time
- the project has no license

Popular formulae (e.g. have more than 1000 [analytics installs in the last 90 days](https://formulae.brew.sh/analytics/install/90d/)) should not be disabled without a deprecation period of at least six months even if e.g. they do not build from source and do not have a license.

Unpopular formulae (e.g. have fewer than 1000 [analytics installs in the last 90 days](https://formulae.brew.sh/analytics/install/90d/)) can be disabled immediately for any of the reasons above, e.g. they cannot be built from source on any supported macOS version or Linux.
They can be manually removed three months after their disable date.

To disable a formula, add a `disable!` call. This call should include a deprecation date in the ISO 8601 format and a deprecation reason:

```ruby
disable! date: "YYYY-MM-DD", because: :reason
```

The `date` parameter should be set to the date that the reason for disabling came into effect. If there is no clear date but the formula needs to be disabled, use today's date. If the `date` parameter is set to a date in the future, the formula will be deprecated until that date (upon which the formula will become disabled).

The `because` parameter can be a preset reason (using a symbol) or a custom reason. See the [Deprecate and Disable Reasons](#deprecate-and-disable-reasons) section below for more details about the `because` parameter.

Similar to deprecated formulae, an optional `replacement_formula` or `replacement_cask` parameter may also be specified for disabled formulae to suggest a replacement formula or cask to the user. The value for the parameter is a string.

```ruby
disable! date: "YYYY-MM-DD", because: :reason, replacement_cask: "foo"
```

## Removal

A formula should be removed if it does not meet our criteria for [acceptable formulae](Acceptable-Formulae.md) or [versioned formulae](Versions.md), has a non-open-source license, or has been disabled for over a year.

**Note: disabled formulae in `homebrew/core` will be automatically removed one year after their disable date.**

## Deprecate and Disable Reasons

When a formula is deprecated or disabled, a reason explaining the action must be provided.

There are two ways to indicate the reason. The preferred way is to use a pre-existing symbol to indicate the reason. The available symbols are listed below and can be found in the [`DeprecateDisable` module](/rubydoc/DeprecateDisable.html.html):

- `:does_not_build`: the formula cannot be built from source on any supported macOS version or Linux.
- `:no_license`: we cannot identify a license for the formula
- `:repo_archived`: the upstream repository has been archived and no replacement is pointed to that we can use
- `:repo_removed`: the upstream repository has been removed and no replacement is mentioned on the homepage that we can use
- `:unmaintained`: the project appears to be abandoned, i.e. it has had no commits for at least a year and has critical bugs or CVEs that have been reported and left unresolved for longer. **Note:** some software is "done"; a lack of activity does not imply a need for removal.
- `:unsupported`: Homebrew's compilation of the software is not supported by the upstream developers (e.g. upstream only supports macOS versions older than 10.15)
- `:deprecated_upstream`: the project is deprecated upstream and no replacement is pointed to that we can use
- `:versioned_formula`: the formula is a versioned formula and no longer [meets the requirements](Versions.md).
- `:checksum_mismatch`: the checksum of the source for the formula's current version has changed since bottles were built and we cannot find a reputable source or statement justifying this

These reasons can be specified by their symbols (the comments show the message that will be displayed to users):

```ruby
# Warning: <formula> has been deprecated because it is deprecated upstream!
deprecate! date: "2020-01-01", because: :deprecated_upstream
```

```ruby
# Error: <formula> has been disabled because it does not build!
disable! date: "2020-01-01", because: :does_not_build
```

If these pre-existing reasons do not fit, a custom reason can be specified. Such reasons should be written to fit into the sentence `<formula> has been deprecated/disabled because it <reason>!`.

A well-worded example of a custom reason would be:

```ruby
# Warning: <formula> has been deprecated because it fetches unversioned dependencies at runtime!
deprecate! date: "2020-01-01", because: "fetches unversioned dependencies at runtime"
```

A poorly-worded example of a custom reason would be:

```ruby
# Error: <formula> has been disabled because it invalid license!
disable! date: "2020-01-01", because: "invalid license"
```
---
last_review_date: "1970-01-01"
---

# Formula Cookbook

A *formula* is a package definition written in Ruby. It can be created with `brew create <URL>` where `<URL>` is a zip or tarball, installed with `brew install <formula>`, and debugged with `brew install --debug --verbose <formula>`. Formulae use the [`Formula` class API](/rubydoc/Formula.html) which provides various Homebrew-specific helpers.

* Table of Contents
{:toc}

## Homebrew terminology

| term                 | description                                                               | example |
| -------------------- | ------------------------------------------------------------------------- | ------- |
| **formula**          | Homebrew package definition that builds from upstream sources             | `/opt/homebrew/Library/Taps/homebrew/homebrew-core/Formula/f/foo.rb` |
| **cask**             | Homebrew package definition that installs pre-compiled binaries built and signed by upstream | `/opt/homebrew/Library/Taps/homebrew/homebrew-cask/Casks/b/bar.rb` |
| **prefix**           | path in which Homebrew is installed                                       | `/opt/homebrew` |
| **keg**              | installation destination directory of a given **formula** version         | `/opt/homebrew/Cellar/foo/0.1` |
| **rack**             | directory containing one or more versioned **kegs**                       | `/opt/homebrew/Cellar/foo` |
| **keg-only**         | a **formula** is *keg-only* if it is not symlinked into Homebrew's prefix | the [`openjdk`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/o/openjdk.rb) formula |
| **opt prefix**       | a symlink to the active version of a **keg**                              | `/opt/homebrew/opt/foo` |
| **Cellar**           | directory containing one or more named **racks**                          | `/opt/homebrew/Cellar` |
| **Caskroom**         | directory containing one or more named **casks**                          | `/opt/homebrew/Caskroom` |
| **tap**              | directory (and usually Git repository) of **formulae**, **casks** and/or **external commands**       | `/opt/homebrew/Library/Taps/homebrew/homebrew-core` |
| **bottle**           | pre-built **keg** poured into a **rack** of the **Cellar** instead of building from upstream sources | `qt--6.5.1.ventura.bottle.tar.gz` |
| **tab**              | information about a **keg**, e.g. whether it was poured from a **bottle** or built from source       | `/opt/homebrew/Cellar/foo/0.1/INSTALL_RECEIPT.json` |
| **Brew Bundle**      | a declarative interface to Homebrew                                                                  | `brew 'myservice', restart_service: true` |
| **Brew Services**    | the Homebrew command to manage background services                                                   | `brew services start myservice` |

## An introduction

Homebrew uses Git for storing formulae and contributing to the project.

As of [Homebrew 4.0.0](https://brew.sh/2023/02/16/homebrew-4.0.0/), formulae are downloaded as JSON from <https://formulae.brew.sh> which is automatically regenerated by a scheduled [Homebrew/formulae.brew.sh](https://github.com/Homebrew/formulae.brew.sh) job from the default branch of the Homebrew/homebrew-core repository.

Homebrew installs formulae to the Cellar at `$(brew --cellar)` and then symlinks some of the installation into the prefix at `$(brew --prefix)` (e.g. `/opt/homebrew`) so that other programs can see what's going on. We suggest running `brew ls` on a few of the kegs in your Cellar to see how it is all arranged.

Packages are installed according to their formulae. Read over a simple one, e.g. `brew edit etl` (or [etl.rb](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/e/etl.rb)) or a more advanced one, e.g. `brew edit git` (or [git.rb](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/g/git.rb)).

## Basic instructions

Make sure you run `brew update` before you start. This ensures your Homebrew installation is a Git repository.

To create or edit formulae locally, you'll need to first [tap `homebrew/core`](FAQ.md#can-i-edit-formulae-myself) if you haven't previously. This clones the Homebrew/homebrew-core Git repository to `$(brew --repository homebrew/core)`. As you're developing, you'll also need to set `HOMEBREW_NO_INSTALL_FROM_API=1` in your shell environment or before any `install`, `reinstall` or `upgrade` commands to force `brew` to use the local repository instead of the API.

Before submitting a new formula make sure your package:

* meets all our [Acceptable Formulae](Acceptable-Formulae.md) requirements
* isn't already in Homebrew (check `brew search <formula>`)
* isn't already waiting to be merged (check the [issue tracker](https://github.com/Homebrew/homebrew-core/pulls))
* is still supported by upstream (i.e. doesn't require extensive patching)
* has a stable, tagged version (i.e. isn't just a GitHub repository with no versions)
* passes all `brew audit --new --formula <formula>` tests

Before submitting a new formula make sure you read over our [contribution guidelines](https://github.com/Homebrew/brew/blob/HEAD/CONTRIBUTING.md#contributing-to-homebrew).

### Grab the URL

Run `brew create` with a URL to the source tarball:

```sh
brew create https://example.com/foo-0.1.tar.gz
```

This creates `$(brew --repository)/Library/Taps/homebrew/homebrew-core/Formula/f/foo.rb` and opens it in your `EDITOR`.

Passing in `--ruby` or `--python` will populate various defaults commonly useful for projects written in those languages.

If `brew` said `Warning: Version cannot be determined from URL` when doing the `create` step, you’ll need to explicitly add the correct [`version`](/rubydoc/Formula.html#version-class_method) to the formula and then save the formula.

Homebrew will try to guess the formula’s name from its URL. If it fails to do so you can override this with `brew create <URL> --set-name <name>`.

### Fill in the `homepage`

**We don’t accept formulae without a [`homepage`](/rubydoc/Formula.html#homepage-class_method)!**

An SSL/TLS (https) [`homepage`](/rubydoc/Formula.html#homepage-class_method) is preferred, if one is available.

Try to summarise from the [`homepage`](/rubydoc/Formula.html#homepage-class_method) what the formula does in the [`desc`](/rubydoc/Formula.html#desc-class_method)ription. Note that the [`desc`](/rubydoc/Formula.html#desc-class_method)ription is automatically prepended with the formula name when printed.

### Fill in the `license`

**We don’t accept new formulae into Homebrew/homebrew-core without a [`license`](/rubydoc/Formula.html#license-class_method)!**

We only accept formulae that use a [Debian Free Software Guidelines license](https://wiki.debian.org/DFSGLicenses) or are released into the public domain following [DFSG Guidelines on Public Domain software](https://wiki.debian.org/DFSGLicenses#Public_Domain).

Use the license identifier from the [SPDX License List](https://spdx.org/licenses/) e.g. `license "BSD-2-Clause"`, or use `license :public_domain` for public domain software.

Use `:any_of`, `:all_of` or `:with` to describe complex license expressions. `:any_of` should be used when the user can choose which license to use. `:all_of` should be used when the user must use all licenses. `:with` should be used to specify a valid SPDX exception. Add `+` to an identifier to indicate that the formulae can be licensed under later versions of the same license.

Check out the [License Guidelines](License-Guidelines.md) for examples of complex license expressions in Homebrew formulae.

### Check the build system

```sh
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source --interactive foo
```

You’re now at a new prompt with the tarball extracted to a temporary sandbox.

Check the package’s `README`. Does the package install with `./configure`, `cmake`, or something else? Delete the commented out `cmake` lines if the package uses `./configure`.

### Check for dependencies

The `README` probably tells you about dependencies and Homebrew or macOS probably already has them. You can check for Homebrew dependencies with `brew search`. Some common dependencies that macOS comes with:

* `libexpat`
* `libGL`
* `libiconv`
* `libpcap`
* `libxml2`
* `python`
* `ruby`

There are plenty of others; check `/usr/lib` for them.

We generally try not to duplicate system libraries and complicated tools in core Homebrew but we do duplicate some commonly used tools.

Special exceptions are OpenSSL and LibreSSL. Things that use either *should* be built using Homebrew’s shipped equivalent and our BrewTestBot's post-install `audit` will warn if it detects you haven't done this.

**Important:** `$(brew --prefix)/bin` is NOT in the `PATH` during formula installation. If you have dependencies at build time, you must specify them and `brew` will add them to the `PATH` or create a [`Requirement`](/rubydoc/Requirement.html).

### Specifying other formulae as dependencies

```ruby
class Foo < Formula
  # ...

  depends_on "httpd" => [:build, :test]
  depends_on xcode: ["9.3", :build]
  depends_on arch: :x86_64
  depends_on "jpeg"
  depends_on macos: :high_sierra
  depends_on "pkgconf"
  depends_on "readline" => :recommended
  depends_on "gtk+" => :optional

  # ...
end
```

A `String` (e.g. `"jpeg"`) specifies a formula dependency.

A `Symbol` (e.g. `:xcode`) specifies a [`Requirement`](/rubydoc/Requirement.html) to restrict installation to systems meeting certain criteria, which can be fulfilled by one or more formulae, casks or other system-wide installed software (e.g. Xcode). Some [`Requirement`](/rubydoc/Requirement.html)s can also take a string or symbol specifying their minimum version that the formula depends on.

A `Hash` (e.g. `=>`) adds information to a dependency. Given a string or symbol, the value can be one or more of the following values:

* `:build` means this is a build-time only dependency so it can be skipped when installing from a bottle or when listing missing dependencies using `brew missing`.
* `:test` means this is only required when running `brew test`.
* `:optional` (not allowed in `Homebrew/homebrew-core`) generates an implicit `with-foo` option for the formula. This means that, given `depends_on "foo" => :optional`, the user must pass `--with-foo` to use the dependency.
* `:recommended` (not allowed in `Homebrew/homebrew-core`) generates an implicit `without-foo` option, meaning that the dependency is enabled by default and the user must pass `--without-foo` to disable this dependency. The default description can be overridden using the [`option`](/rubydoc/Formula.html#option-class_method) syntax (in this case, the [`option` declaration](#adding-optional-steps) must precede the dependency):

```ruby
option "with-foo", "Compile with foo bindings" # This overrides the generated description if you want to
depends_on "foo" => :optional # Generated description would otherwise be "Build with foo support"
```

* `"<option-name>"` (not allowed in `Homebrew/homebrew-core`) requires a dependency to have been built with the specified option.

### Specifying conflicts with other formulae

Sometimes there’s a hard conflict between formulae that can’t be avoided or circumvented with [`keg_only`](/rubydoc/Formula.html#keg_only-class_method).

A good example for minor conflict is the [`mbedtls`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/m/mbedtls.rb) formula, which ships and compiles a "Hello World" executable. This is obviously non-essential to `mbedtls`’s functionality, and as conflict with the popular GNU [`hello`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/h/hello.rb) formula would be overkill, we just [remove it](https://github.com/Homebrew/homebrew-core/blob/442f9cc511ce6dfe75b96b2c83749d90dde914d2/Formula/m/mbedtls.rb#L52-L53) during the installation process.

[`pdftohtml`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/p/pdftohtml.rb) provides an example of a serious conflict, where each listed formula ships an identically named binary that is essential to functionality, so a [`conflicts_with`](/rubydoc/Formula.html#conflicts_with-class_method) is preferable.

As a general rule, [`conflicts_with`](/rubydoc/Formula.html#conflicts_with-class_method) should be a last-resort option. It’s a fairly blunt instrument.

The syntax for a conflict that can’t be worked around is:

```ruby
conflicts_with "blueduck", because: "yellowduck also ships a duck binary"
```

### Formulae revisions

In Homebrew we sometimes accept formulae updates that don’t include a version bump. These include resource updates, new patches or fixing a security issue with a formula.

Occasionally, these updates require a forced-recompile of the formula itself or its dependents to either ensure formulae continue to function as expected or to close a security issue. This forced-recompile is known as a [`revision`](/rubydoc/Formula.html#revision-class_method) and is inserted underneath the [`homepage`](/rubydoc/Formula.html#homepage-class_method)/[`url`](/rubydoc/Formula.html#url-class_method)/[`sha256`](/rubydoc/Formula.html#sha256-class_method)/[`license`](/rubydoc/Formula.html#license-class_method) block.

When a dependent of a formula fails to build against a new version of that dependency it must receive a [`revision`](/rubydoc/Formula.html#revision-class_method). An example of such failure is in [this issue report](https://github.com/Homebrew/legacy-homebrew/issues/31195) and [its fix](https://github.com/Homebrew/legacy-homebrew/pull/31207).

[`revision`](/rubydoc/Formula.html#revision-class_method)s are also used for formulae that move from the system OpenSSL to the Homebrew-shipped OpenSSL without any other changes to that formula. This ensures users aren’t left exposed to the potential security issues of the outdated OpenSSL. An example of this can be seen in [this commit](https://github.com/Homebrew/homebrew-core/commit/0d4453a91923e6118983961e18d0609e9828a1a4).

### Version scheme changes

Sometimes formulae have version schemes that change such that a direct comparison between two versions no longer produces the correct result. For example, a project might be version `13` and then decide to become `1.0.0`. As `13` is translated to `13.0.0` by our versioning system by default this requires intervention.

When a version scheme of a formula fails to recognise a new version as newer it must receive a [`version_scheme`](/rubydoc/Formula.html#version_scheme-class_method). An example of this can be seen in [this pull request](https://github.com/Homebrew/homebrew-core/pull/4006).

### Double-check for dependencies

When you already have a lot of formulae installed, it's easy to miss a common dependency. You can double-check which libraries a binary links to with the `otool` command (perhaps you need to use `xcrun otool`):

```console
$ otool -L /opt/homebrew/bin/ldapvi
/opt/homebrew/bin/ldapvi:
    /opt/homebrew/opt/openssl/lib/libssl.1.0.0.dylib (compatibility version 1.0.0, current version 1.0.0)
    /opt/homebrew/opt/openssl/lib/libcrypto.1.0.0.dylib (compatibility version 1.0.0, current version 1.0.0)
    /opt/homebrew/lib/libglib-2.0.0.dylib (compatibility version 4201.0.0, current version 4201.0.0)
    /opt/homebrew/opt/gettext/lib/libintl.8.dylib (compatibility version 10.0.0, current version 10.2.0)
    /opt/homebrew/opt/readline/lib/libreadline.6.dylib (compatibility version 6.0.0, current version 6.3.0)
    /opt/homebrew/lib/libpopt.0.dylib (compatibility version 1.0.0, current version 1.0.0)
    /usr/lib/libncurses.5.4.dylib (compatibility version 5.4.0, current version 5.4.0)
    /System/Library/Frameworks/LDAP.framework/Versions/A/LDAP (compatibility version 1.0.0, current version 2.4.0)
    /usr/lib/libresolv.9.dylib (compatibility version 1.0.0, current version 1.0.0)
    /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1213.0.0)
```

### Specifying macOS components as dependencies

If a formula dependency is required on all platforms but can be handled by a component that ships with macOS, specify it with [`uses_from_macos`](/rubydoc/Formula.html#uses_from_macos-class_method). On Linux it acts like [`depends_on`](/rubydoc/Formula.html#depends_on-class_method), while on macOS it's ignored unless the host system is older than the optional `since:` parameter.

For example, to require the `bzip2` formula on Linux while relying on built-in `bzip2` on macOS:

```ruby
uses_from_macos "bzip2"
```

To require the `perl` formula only when building or testing on Linux:

```ruby
uses_from_macos "perl" => [:build, :test]
```

To require the `curl` formula on Linux and pre-macOS 12:

```ruby
uses_from_macos "curl", since: :monterey
```

### Specifying gems, Python modules, Go projects, etc. as dependencies

Homebrew doesn’t package already-packaged language-specific libraries. These should be installed directly from `gem`/`cpan`/`pip` etc.

### Ruby Gem Dependencies

The preferred mechanism for installing gem dependencies is to use `bundler` with the upstream's `Gemfile.lock`. This requires the upstream checks in their `Gemfile.lock`, so if they don't, it's a good idea to file an issue and ask them to do so. Assuming they have one, this is as simple as:

```ruby
ENV["GEM_HOME"] = libexec
system "bundle", "install", "--without", "development"
```

From there, you can build and install the project itself:

```ruby
system "gem", "build", "<project>.gemspec"
system "gem", "install", "--ignore-dependencies", "<project>-#{version}.gem"
```

And install any bins, and munge their shebang lines, with:

```ruby
bin.install libexec/"bin/<bin>"
bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV.fetch("GEM_HOME", nil))
```

### Python dependencies

For python we use [`resource`](/rubydoc/Formula.html#resource-class_method)s for dependencies and there's automation to generate these for you. Running `brew update-python-resources <formula>` will automatically add the necessary [`resource`](/rubydoc/Formula.html#resource-class_method) stanzas for the dependencies of your Python application to the formula. Note that `brew update-python-resources` is run automatically by `brew create` if you pass the `--python` switch. If `brew update-python-resources` is unable to determine the correct `resource` stanzas, [homebrew-pypi-poet](https://github.com/tdsmith/homebrew-pypi-poet) is a good third-party alternative that may help.

### All other cases

If all else fails, you'll want to use [`resource`](/rubydoc/Formula.html#resource-class_method)s for all other language-specific dependencies. This requires you to specify both a specific URL for a version and the sha256 checksum for security. Here's an example:

```ruby
class Foo < Formula
  # ...
  url "https://example.com/foo-1.0.tar.gz"

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  def install
    resource("pycrypto").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
  end
end
```

[`jrnl`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/j/jrnl.rb) is an example of a formula that does this well. The end result means the user doesn't have to use `pip` or Python and can just run `jrnl`.

### Install the formula

```sh
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source --verbose --debug foo
```

`--debug` will ask you to open an interactive shell if the build fails so you can try to figure out what went wrong.

Check the top of the e.g. `./configure` output. Some configure scripts do not recognise e.g. `--disable-debug`. If you see a warning about it, remove the option from the formula.

### Add a test to the formula

Add a valid test to the [`test do`](/rubydoc/Formula.html#test-class_method) block of the formula. This will be run by `brew test foo` and [BrewTestBot](BrewTestBot.md).

The [`test do`](/rubydoc/Formula.html#test-class_method) block automatically creates and changes to a temporary directory which is deleted after run. You can access this [`Pathname`](/rubydoc/Pathname.html) with the [`testpath`](/rubydoc/Formula.html#testpath-instance_method) function. The environment variable `HOME` is set to [`testpath`](/rubydoc/Formula.html#testpath-instance_method) within the [`test do`](/rubydoc/Formula.html#test-class_method) block.

We want tests that don't require any user input and test the basic functionality of the application. For example `foo build-foo input.foo` is a good test and (despite their widespread use) `foo --version` and `foo --help` are bad tests. However, a bad test is better than no test at all.

See the [`cmake`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/c/cmake.rb) formula for an example of a good test. It writes a basic `CMakeLists.txt` file into the test directory then calls CMake to generate Makefiles. This test checks that CMake doesn't e.g. segfault during basic operation.

You can check that the output is as expected with `assert_equal` or `assert_match` on the output of the formula's [assertions](/rubydoc/Homebrew/Assertions.html) such as in this example from the [`envv`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/e/envv.rb) formula:

```ruby
assert_equal "mylist=A:C; export mylist", shell_output("#{bin}/envv del mylist B").strip
```

You can also check that an output file was created:

```ruby
assert_predicate testpath/"output.txt", :exist?
```

Some advice for specific cases:

* If the formula is a library, compile and run some simple code that links against it. It could be taken from upstream's documentation / source examples. A good example is [`tinyxml2`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/t/tinyxml2.rb)'s test, which writes a small C++ source file into the test directory, compiles and links it against the tinyxml2 library and finally checks that the resulting program runs successfully.
* If the formula is for a GUI program, try to find some function that runs as command-line only, like a format conversion, reading or displaying a config file, etc.
* If the software cannot function without credentials or requires a virtual machine, docker instance, etc. to run, a test could be to try to connect with invalid credentials (or without credentials) and confirm that it fails as expected. This is preferred over mocking a dependency.
* Homebrew comes with a number of [standard test fixtures](https://github.com/Homebrew/brew/tree/HEAD/Library/Homebrew/test/support/fixtures), including numerous sample images, sounds, and documents in various formats. You can get the file path to a test fixture with e.g. `test_fixtures("test.svg")`.
* If your test requires a test file that isn't a standard test fixture, you can install it from a source repository during the `test` phase with a [`resource`](/rubydoc/Formula.html#resource-class_method) block, like this:

```ruby
test do
  resource "testdata" do
    url "https://example.com/input.foo"
    sha256 "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
  end

  resource("testdata").stage do
    assert_match "OK", shell_output("#{bin}/foo build-foo input.foo")
  end
end
```

* If the binary only writes to `stderr`, you can redirect `stderr` to `stdout` for assertions with `shell_output`. For example:

```ruby
test do
  assert_match "Output on stderr", shell_output("#{bin}/formula-program 2>&1", 2)
end
```

### Manuals

Homebrew expects to find manual pages in `#{prefix}/share/man/...`, and not in `#{prefix}/man/...`.

Some software installs to `man` instead of `share/man`, so check the output and add a `"--mandir=#{man}"` to the `./configure` line if needed.

### Caveats

In case there are specific issues with the Homebrew packaging (compared to how the software is installed from other sources) a `caveats` block can be added to the formula to warn users. This can indicate non-standard install paths, like this example from the [`ruby`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/r/ruby.rb) formula:

    ==> Caveats
    By default, binaries installed by gem will be placed into:
      /opt/homebrew/lib/ruby/gems/3.4.0/bin

    You may want to add this to your PATH.

### A quick word on naming

Name the formula like the project markets the product. So it’s `pkgconf`, not `pkgconfig`; `sdl_mixer`, not `sdl-mixer` or `sdlmixer`.

The only exception is stuff like “Apache Ant”. Apache sticks “Apache” in front of everything, but we use the formula name `ant`. We only include the prefix in cases like `gnuplot` (because it’s part of the name) and `gnu-go` (because everyone calls it “GNU Go”—nobody just calls it “Go”). The word “Go” is too common and there are too many implementations of it.

If you’re not sure about the name, check its homepage, Wikipedia page and [what Debian calls it](https://www.debian.org/distrib/packages).

When Homebrew already has a formula called `foo` we typically do not accept requests to replace that formula with something else also named `foo`. This is to avoid both confusing and surprising users’ expectations.

When two formulae share an upstream name, e.g. [AESCrypt](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/a/aescrypt.rb) and [AES Crypt](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/a/aescrypt-packetizer.rb) the newer formula must typically adapt its name to avoid conflict with the current formula.

If you’re *still* not sure, just commit. We’ll apply some arbitrary rule and make a decision 😉.

When importing classes, Homebrew will require the formula and then create an instance of the class. It does this by assuming the formula name can be directly converted to the class name using a `regexp`. The rules are simple:

* `foo-bar.rb` => `FooBar`
* `foobar.rb` => `Foobar`

Thus, if you change the name of the class, you must also rename the file. Filenames should be all lowercase, and class names should be the strict CamelCase equivalent, e.g. formulae `gnu-go` and `sdl_mixer` become classes `GnuGo` and `SdlMixer`, even if part of their name is an acronym.

Add aliases by creating symlinks in an `Aliases` directory in the tap root.

### Audit the formula

You can run `brew audit --strict --online` to test formulae for adherence to Homebrew house style, which is loosely based on the [Ruby Style Guide](https://github.com/rubocop-hq/ruby-style-guide#the-ruby-style-guide). The `audit` command includes warnings for trailing whitespace, preferred URLs for certain source hosts, and many other style issues. Fixing these warnings before committing will make the process a lot quicker for everyone.

New formulae being submitted to Homebrew should run `brew audit --new --formula foo`. This command is performed by BrewTestBot on new submissions as part of the automated build and test process, and highlights more potential issues than the standard audit.

Use `brew info` and check if the version guessed by Homebrew from the URL is correct. Add an explicit [`version`](/rubydoc/Formula.html#version-class_method) if not.

### Commit

Everything is built on Git, so contribution is easy:

```sh
brew update # required in more ways than you think (initialises the Homebrew/brew Git repository if you don't already have it)
cd "$(brew --repository homebrew/core)"
# Create a new git branch for your formula so your pull request is easy to
# modify if any changes come up during review.
git checkout -b <some-descriptive-name> origin/HEAD
git add Formula/f/foo.rb
git commit
```

The established standard for Git commit messages is:

* the first line is a commit summary of *50 characters or less*
* two (2) newlines, then
* explain the commit thoroughly.

At Homebrew, we require the name of the formula up front like so: `foobar 7.3 (new formula)`.

This may seem crazy short, but you’ll find that forcing yourself to summarise the commit encourages you to be atomic and concise. If you can’t summarise it in 50 to 80 characters, you’re probably trying to commit two commits as one. For a more thorough explanation, please read Tim Pope’s excellent blog post, [A Note About Git Commit Messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).

The required commit message format for simple version updates is `foobar 7.3` and for fixes is `foobar: fix flibble matrix.`. Please squash your commits into one with this message format, otherwise your PR will be replaced by our autosquash workflow.

Ensure you reference any relevant GitHub issue, e.g. `Closes #12345` in the commit message. Homebrew’s history is the first thing future contributors will look to when trying to understand the current state of formulae they’re interested in.

### Push

Now you just need to push your commit to GitHub.

If you haven’t forked Homebrew yet, [go to the Homebrew/homebrew-core repository and hit the Fork button](https://github.com/Homebrew/homebrew-core).

If you have already forked Homebrew on GitHub, then you can manually push (just make sure you have been pulling from the `Homebrew/homebrew-core` default branch):

```sh
git push https://github.com/myname/homebrew-core/ <what-you-named-your-branch>
```

Now, [open a pull request](How-To-Open-a-Homebrew-Pull-Request.md) for your changes.

* One formula per commit; one commit per formula.
* Keep merge commits out of the pull request.

## Convenience tools

### Messaging

Three commands are provided for displaying informational messages to the user:

* `ohai` for general info
* `opoo` for warning messages
* `odie` for error messages and immediately exiting

Use `odie` when you need to exit a formula gracefully for any reason. For example:

```ruby
if build.head?
  lib_jar = Dir["cfr-*-SNAPSHOT.jar"]
  doc_jar = Dir["cfr-*-SNAPSHOT-javadoc.jar"]
  odie "Unexpected number of artifacts!" if (lib_jar.length != 1) || (doc_jar.length != 1)
end
```

### Standard arguments

For any formula using certain well-known build systems, there will be arguments that should be passed during compilation so that the build conforms to Homebrew standards. These have been collected into a set of `std_*_args` methods. Detailed information about each of those methods can be found in the [`Formula` class API](/rubydoc/Formula.html) documentation.

Most of these methods accept parameters to customize their output. For example, to set the install prefix to [**`libexec`**](#variables-for-directory-locations) for `configure` or `cmake`:

```ruby
system "./configure", *std_configure_args(prefix: libexec)
system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec)
```

The `std_*_args` methods, as well as the arguments they pass, are:

#### `std_cabal_v2_args`

```ruby
"--jobs=#{ENV.make_jobs}"
"--max-backjumps=100000"
"--install-method=copy"
"--installdir=#{bin}"
```

#### `std_cargo_args`

```ruby
"--locked"
"--root=#{root}"
"--path=#{path}"
```

#### `std_cmake_args`

```ruby
"-DCMAKE_INSTALL_PREFIX=#{install_prefix}"
"-DCMAKE_INSTALL_LIBDIR=#{install_libdir}"
"-DCMAKE_BUILD_TYPE=Release"
"-DCMAKE_FIND_FRAMEWORK=#{find_framework}"
"-DCMAKE_VERBOSE_MAKEFILE=ON"
"-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=#{HOMEBREW_LIBRARY_PATH}/cmake/trap_fetchcontent_provider.cmake"
"-Wno-dev"
"-DBUILD_TESTING=OFF"
```

#### `std_configure_args`

```ruby
"--disable-debug"
"--disable-dependency-tracking"
"--prefix=#{prefix}"
"--libdir=#{libdir}"
```

#### `std_go_args`

```ruby
"-trimpath"
"-o=#{output}"
```

It also provides a convenient way to set `-ldflags`, `-gcflags`, and `-tags`, see examples: [`babelfish`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/b/babelfish.rb) and [`wazero`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/w/wazero.rb) formulae.

#### `std_meson_args`

```ruby
"--prefix=#{prefix}"
"--libdir=#{lib}"
"--buildtype=release"
"--wrap-mode=nofallback"
```

#### `std_npm_args`

```ruby
"-ddd"
"--global"
"--build-from-source"
"--cache=$(brew --cache)/npm_cache"
"--prefix=#{libexec}"
```

#### `std_pip_args`

```ruby
"--verbose"
"--no-deps"
"--no-binary=:all:"
"--ignore-installed"
"--no-compile"
```

#### `std_zig_args`

```ruby
"--prefix"
prefix
"--release=#{release_mode}"
"-Doptimize=Release#{release_mode}"
"--summary"
"all"
```

`release_mode` is a symbol that accepts only `:fast`, `:safe`, and `:small` values (with `:fast` being default).

### `bin.install "foo"`

You’ll see stuff like this in some formulae. This moves the file `foo` into the formula’s `bin` directory (`/opt/homebrew/Cellar/pkg/0.1/bin`) and makes it executable (`chmod 0555 foo`). Variables for the most common [directory locations](#variables-for-directory-locations) are available.

You can also rename the file during the installation process. This can be useful for adding a prefix to binaries that would otherwise cause conflicts with another formula, or for removing a file extension. For example, to install `foo.py` into the formula's `bin` directory (`/opt/homebrew/Cellar/pkg/0.1/bin`) as just `foo` instead of `foo.py`:

```ruby
bin.install "foo.py" => "foo"
```

### `inreplace`

[`inreplace`](/rubydoc/Utils/Inreplace.html) is a convenience function that can edit files in-place. For example:

```ruby
inreplace "path", before, after
```

`before` and `after` can be strings or regular expressions. You should use the block form if you need to make multiple replacements in a file:

```ruby
inreplace "path" do |s|
  s.gsub!(/foo/, "bar")
  s.gsub! "123", "456"
end
```

Make sure you modify `s`! This block ignores the returned value.

[`inreplace`](/rubydoc/Utils/Inreplace.html) should be used instead of patches when patching something that will never be accepted upstream, e.g. making the software’s build system respect Homebrew’s installation hierarchy. If it's something that affects both Homebrew and MacPorts (i.e. macOS specific) it should be turned into an upstream submitted patch instead.

If you need to modify variables in a `Makefile`, rather than using [`change_make_var!`](/rubydoc/StringInreplaceExtension.html#change_make_var!-instance_method) within an [`inreplace`](/rubydoc/Utils/Inreplace.html), try passing them as arguments to `make`:

```ruby
system "make", "target", "VAR2=value1", "VAR2=value2", "VAR3=values can have spaces"
```

```ruby
system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
```

Note that values *can* contain unescaped spaces if you use the multiple-argument form of `system`.

## Patches

While [`patch`](/rubydoc/Formula.html#patch-class_method)es should generally be avoided, sometimes they are temporarily necessary.

When [`patch`](/rubydoc/Formula.html#patch-class_method)ing (i.e. fixing header file inclusion, fixing compiler warnings, etc.) the first thing to do is check whether the upstream project is aware of the issue. If not, file a bug report and/or submit your patch for inclusion. We may sometimes still accept your patch before it was submitted upstream but by getting the ball rolling on fixing the upstream issue you reduce the length of time we have to carry the patch around.

*Always justify a [`patch`](/rubydoc/Formula.html#patch-class_method) with a code comment!* Otherwise, nobody will know when it is safe to remove the patch, or safe to leave it in when updating the formula. The comment should include a link to the relevant upstream issue(s).

External [`patch`](/rubydoc/Formula.html#patch-class_method)es can be declared using resource-style blocks:

```ruby
patch do
  url "https://example.com/example_patch.diff"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
end
```

A strip level of `-p1` is assumed. It can be overridden using a symbol argument:

```ruby
patch :p0 do
  url "https://example.com/example_patch.diff"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
end
```

[`patch`](/rubydoc/Formula.html#patch-class_method)es can be declared in [`stable`](/rubydoc/Formula.html#stable-class_method) and [`head`](/rubydoc/Formula.html#head-class_method) blocks. Always use a block instead of a conditional, i.e. `stable do ... end` instead of `if build.stable? then ... end`.

```ruby
stable do
  # ...

  patch do
    url "https://example.com/example_patch.diff"
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
  end
end
```

Embedded (**END**) patches can be declared like so:

```ruby
patch :DATA
patch :p0, :DATA
```

with the patch data included at the end of the file:

    __END__
    diff --git a/foo/showfigfonts b/foo/showfigfonts
    index 643c60b..543379c 100644
    --- a/foo/showfigfonts
    +++ b/foo/showfigfonts
    @@ -14,6 +14,7 @@
    …

Patches can also be embedded by passing a string. This makes it possible to provide multiple embedded patches while making only some of them conditional.

```ruby
patch :p0, "..."
```

In embedded patches, the string "HOMEBREW\_PREFIX" is replaced with the value of the constant `HOMEBREW_PREFIX` before the patch is applied.

In external patches, the string "@@HOMEBREW\_PREFIX@@" is replaced with the value of the constant `HOMEBREW_PREFIX` before the patch is applied.

### Creating the diff

```sh
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --interactive --git foo
# (make some edits)
git diff | pbcopy
brew edit foo
```

Now just paste into the formula after `__END__`.

Instead of `git diff | pbcopy`, for some editors `git diff >> path/to/your/formula/foo.rb` might help you ensure that the patch is not altered, e.g. whitespace removal, indentation changes, etc.

## Advanced formula tricks

See the [`Formula` class API](/rubydoc/Formula.html) documentation for the full list of methods available within a formula. If anything isn’t clear, you can usually figure it out by `grep`ping the `$(brew --repository homebrew/core)` directory for examples. Please submit a pull request to amend this document if you think it will help!

### Handling different system configurations

Often, formulae need different dependencies, resources, patches, conflicts, deprecations or `keg_only` statuses on different OSes and architectures. In these cases, the components can be nested inside `on_macos`, `on_linux`, `on_arm` or `on_intel` blocks. For example, here's how to add `gcc` as a Linux-only dependency:

```ruby
on_linux do
  depends_on "gcc"
end
```

Components can also be declared for specific macOS versions or version ranges. For example, to declare a dependency only on High Sierra, nest the `depends_on` call inside an `on_high_sierra` block. Add an `:or_older` or `:or_newer` parameter to the `on_high_sierra` method to add the dependency to all macOS versions that meet the condition. For example, to add `gettext` as a build dependency on Mojave and all later macOS versions, use:

```ruby
on_mojave :or_newer do
  depends_on "gettext" => :build
end
```

Sometimes, a dependency is needed on certain macOS versions *and* on Linux. In these cases, a special `on_system` method can be used:

```ruby
on_system :linux, macos: :sierra_or_older do
  depends_on "gettext" => :build
end
```

To check multiple conditions, nest the corresponding blocks. For example, the following code adds a `gettext` build dependency when on ARM *and* macOS:

```ruby
on_macos do
  on_arm do
    depends_on "gettext" => :build
  end
end
```

#### Inside `def install` and `test do`

Inside `def install` and `test do`, don't use these `on_*` methods. Instead, use `if` statements and the following conditionals:

* `OS.mac?` and `OS.linux?` return `true` or `false` based on the OS
* `Hardware::CPU.arm?` and `Hardware::CPU.intel?` return `true` or `false` based on the arch
* `MacOS.version` returns the current macOS version. Use `==`, `<=` or `>=` to compare to symbols corresponding to macOS versions (e.g. `if MacOS.version >= :mojave`)

See the [`icoutils`](https://github.com/Homebrew/homebrew-core/blob/442f9cc511ce6dfe75b96b2c83749d90dde914d2/Formula/i/icoutils.rb#L36) formula for an example.

### `livecheck` blocks

When `brew livecheck` is unable to identify versions for a formula, we can control its behavior using a `livecheck` block. Here is a simple example to check a page for links containing a filename like `example-1.2.tar.gz`:

```ruby
livecheck do
  url "https://www.example.com/downloads/"
  regex(/href=.*?example[._-]v?(\d+(?:\.\d+)+)\.t/i)
end
```

For `url`/`regex` guidelines and additional `livecheck` block examples, refer to the [`brew livecheck`](Brew-Livecheck.md) documentation. For more technical information on the methods used in a `livecheck` block, please refer to the [`Livecheck` class](/rubydoc/Livecheck.html) documentation.

### Excluding formula from autobumping

By default, all new formulae in the `Homebrew/homebrew-core` repository are autobumped. This means that future updates are handled automatically by Homebrew CI jobs, and contributors do not have to submit pull requests.

Sometimes, we want to exclude a formula from this list, for one reason or another. This can be done by adding the `no_autobump!` method in the formula definition; a reason must be provided with the `because:` parameter. It accepts a string or a symbol that corresponds to a preset reason, for example:

```ruby
no_autobump! because: :bumped_by_upstream
```

A complete list of allowed symbols can be found in [`NO_AUTOBUMP_REASONS_LIST`](/rubydoc/top-level-namespace.html#NO_AUTOBUMP_REASONS_LIST-constant).

See our [Autobump](Autobump.md) documentation for more information about the autobump process.

### URL download strategies

When parsing a download URL, Homebrew auto-detects the resource type it points to, whether archive (e.g. tarball, zip) or version control repository (e.g. Git, Subversion, Mercurial) and chooses an appropriate download strategy. Some strategies can be passed additional options to alter what's downloaded. For example, to fetch a formula's source code and infer its version number from a specific tag in a Git repository (useful for packages that rely on Git submodules), specify [`url`](/rubydoc/Formula.html#url-class_method) with the `:tag` and `:revision` options, like so:

```ruby
class Foo < Formula
  # ...
  url "https://github.com/some/package.git",
      tag:      "v1.6.2",
      revision: "344cd2ee3463abab4c16ac0f9529a846314932a2"
end
```

If fetching from a Subversion or Mercurial repository, specify `revision` and `version` separately:

```ruby
class Bar < Formula
  # ...
  url "https://svn.code.sf.net/p/package/code/stable", revision: "4687"
  version "12.1.8"
end
```

To fetch specific revisions of Subversion externals, specify `revisions`:

```ruby
class Baz < Formula
  # ...
  url "svn://source.something.org/package/trunk/",
      revisions: { trunk: "22916", "libsomething" => "31045" }
  version "7.2.11"
end
```

If not inferable, specify which of Homebrew's built-in download strategies to use with the `using:` option. For example:

```ruby
class Nginx < Formula
  desc "HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server"
  homepage "https://nginx.org/"
  url "https://nginx.org/download/nginx-1.23.2.tar.gz", using: :homebrew_curl
  sha256 "a80cc272d3d72aaee70aa8b517b4862a635c0256790434dbfc4d618a999b0b46"
  head "https://hg.nginx.org/nginx/", using: :hg
end
```

Homebrew offers these anonymous download strategies.

| `using:` value   | download strategy                | requirements |
| ---------------- | -------------------------------- | ------------ |
| `:bzr`           | fetch from Bazaar repository     | `breezy` installed |
| `:curl`          | download using `curl` (default)  | |
| `:cvs`           | fetch from CVS repository        | `cvs` installed |
| `:fossil`        | fetch from Fossil repository     | `fossil` installed |
| `:git`           | fetch from Git repository        | `git` installed |
| `:hg`            | fetch from Mercurial repository  | `hg` installed |
| `:homebrew_curl` | download using brewed `curl`     | `curl` installed |
| `:nounzip`       | download without decompressing   | |
| `:post`          | download using `curl` via POST   | `data:` [hash of parameters](Cask-Cookbook.md#additional-url-parameters) |
| `:svn`           | fetch from Subversion repository | `svn` installed |

If you need more control over the way files are downloaded and staged, you can create a custom download strategy and specify it with the `:using` option:

```ruby
class MyDownloadStrategy < SomeHomebrewDownloadStrategy
  def fetch(timeout: nil, **options)
    opoo "Unhandled options in #{self.class}#fetch: #{options.keys.join(", ")}" unless options.empty?

    # downloads output to `temporary_path`
  end
end

class Foo < Formula
  url "something", using: MyDownloadStrategy
end
```

### Unstable versions (`head`)

Formulae can specify an alternate download for the upstream project's development/cutting-edge source (e.g. `master`/`main`/`trunk`) using [`head`](/rubydoc/Formula.html#head-class_method), which can be activated by passing `--HEAD` when installing. Specifying it is done in the same manner as [`url`](/rubydoc/Formula.html#url-class_method), with added conventions for fetching from version control repositories:

* Git repositories **must always** specify `branch:`. If the repository is very large, specify `only_path` to [limit the checkout to one path](Cask-Cookbook.md#git-urls).

```sh
head "<https://github.com/some/package.git>", branch: "main"
```

* Mercurial repositories need `branch:` specified to fetch a branch other than "default".

* Subversion repositories can specify `trust_cert: true` to [skip interactive certificate prompts](Cask-Cookbook.md#subversion-urls).

* CVS repositories can specify `module:` to check out a specific module.

You can also bundle the URL and any `head`-specific dependencies and resources in a `head do` block.

```ruby
class Foo < Formula
  # ...

  head do
    url "https://hg.sr.ht/~user/foo", using: :hg, branch: "develop"

    depends_on "pkgconf" => :build

    resource "package" do
      url "https://github.com/other/package.git", branch: "main"
    end
  end
end
```

You can test whether the [`head`](/rubydoc/Formula.html#head-class_method) is being built with `build.head?` in the `install` method.

### Compiler selection

Sometimes a package fails to build when using a certain compiler. Since recent [Xcode versions](Xcode.md) no longer include a GCC compiler we cannot simply force the use of GCC. Instead, the correct way to declare this is with the [`fails_with`](/rubydoc/Formula.html#fails_with-class_method) DSL method. A properly constructed [`fails_with`](/rubydoc/Formula.html#fails_with-class_method) block documents the latest compiler build version known to cause compilation to fail, and the cause of the failure. For example:

```ruby
fails_with :clang do
  build 211
  cause "Miscompilation resulting in segfault on queries"
end

fails_with :gcc do
  version "5" # fails with GCC 5.x and earlier
  cause "Requires C++17 support"
end

fails_with gcc: "7" do
  version "7.1" # fails with GCC 7.0 and 7.1 but not 7.2, or any other major GCC version
  cause <<-EOS
    warning: dereferencing type-punned pointer will break strict-aliasing rules
    Fixed in GCC 7.2, see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=42136
  EOS
end
```

For `:clang`, `build` takes an integer (you can find this number in your `brew --config` output), while `:gcc` uses either just `version` which takes a string to indicate the last problematic GCC version, or a major version argument combined with `version` to single out a range of specific GCC releases. `cause` takes a string, and the use of heredocs is encouraged to improve readability and allow for more comprehensive documentation.

[`fails_with`](/rubydoc/Formula.html#fails_with-class_method) declarations can be used with any of `:gcc`, `:llvm`, and `:clang`. Homebrew will use this information to select a working compiler (if one is available).

### Just moving some files

When your code in the install function is run, the current working directory is set to the extracted tarball. This makes it easy to just move some files:

```ruby
prefix.install "file1", "file2"
```

Or everything:

```ruby
prefix.install Dir["output/*"]
```

Or just the tarball's top-level files like README, LICENSE etc.:

```ruby
prefix.install_metafiles
```

Generally we'd rather you were specific about which files or directories need to be installed rather than installing everything.

#### Variables for directory locations

| name                  | default path                                   | example |
| --------------------- | ---------------------------------------------- | ------- |
| **`HOMEBREW_PREFIX`** | same as output of `$(brew --prefix)`           | `/opt/homebrew` |
| **`etc`**             | `#{HOMEBREW_PREFIX}/etc`                       | `/opt/homebrew/etc` |
| **`pkgetc`**          | `#{HOMEBREW_PREFIX}/etc/#{name}`               | `/opt/homebrew/etc/foo` |
| **`var`**             | `#{HOMEBREW_PREFIX}/var`                       | `/opt/homebrew/var` |
| **`prefix`**          | `#{HOMEBREW_PREFIX}/Cellar/#{name}/#{version}` | `/opt/homebrew/Cellar/foo/0.1` |
| **`opt_prefix`**      | `#{HOMEBREW_PREFIX}/opt/#{name}`               | `/opt/homebrew/opt/foo` |
| **`bin`**             | `#{prefix}/bin`                                | `/opt/homebrew/Cellar/foo/0.1/bin` |
| **`opt_bin`**         | `#{opt_prefix}/bin`                            | `/opt/homebrew/opt/foo/bin` |
| **`doc`**             | `#{prefix}/share/doc/#{name}`                  | `/opt/homebrew/Cellar/foo/0.1/share/doc/foo` |
| **`include`**         | `#{prefix}/include`                            | `/opt/homebrew/Cellar/foo/0.1/include` |
| **`opt_include`**     | `#{opt_prefix}/include`                        | `/opt/homebrew/opt/foo/include` |
| **`info`**            | `#{prefix}/share/info`                         | `/opt/homebrew/Cellar/foo/0.1/share/info` |
| **`lib`**             | `#{prefix}/lib`                                | `/opt/homebrew/Cellar/foo/0.1/lib` |
| **`opt_lib`**         | `#{opt_prefix}/lib`                            | `/opt/homebrew/opt/foo/lib` |
| **`libexec`**         | `#{prefix}/libexec`                            | `/opt/homebrew/Cellar/foo/0.1/libexec` |
| **`opt_libexec`**     | `#{opt_prefix}/libexec`                        | `/opt/homebrew/opt/foo/libexec` |
| **`man`**             | `#{prefix}/share/man`                          | `/opt/homebrew/Cellar/foo/0.1/share/man` |
| **`man[1-8]`**        | `#{prefix}/share/man/man[1-8]`                 | `/opt/homebrew/Cellar/foo/0.1/share/man/man[1-8]` |
| **`sbin`**            | `#{prefix}/sbin`                               | `/opt/homebrew/Cellar/foo/0.1/sbin` |
| **`opt_sbin`**        | `#{opt_prefix}/sbin`                           | `/opt/homebrew/opt/foo/sbin` |
| **`share`**           | `#{prefix}/share`                              | `/opt/homebrew/Cellar/foo/0.1/share` |
| **`opt_share`**       | `#{opt_prefix}/share`                          | `/opt/homebrew/opt/foo/share` |
| **`pkgshare`**        | `#{prefix}/share/#{name}`                      | `/opt/homebrew/Cellar/foo/0.1/share/foo` |
| **`opt_pkgshare`**    | `#{opt_prefix}/share/#{name}`                  | `/opt/homebrew/opt/foo/share/foo` |
| **`elisp`**           | `#{prefix}/share/emacs/site-lisp/#{name}`      | `/opt/homebrew/Cellar/foo/0.1/share/emacs/site-lisp/foo` |
| **`opt_elisp`**       | `#{opt_prefix}/share/emacs/site-lisp/#{name}`  | `/opt/homebrew/opt/foo/share/emacs/site-lisp/foo` |
| **`frameworks`**      | `#{prefix}/Frameworks`                         | `/opt/homebrew/Cellar/foo/0.1/Frameworks` |
| **`opt_frameworks`**  | `#{opt_prefix}/Frameworks`                     | `/opt/homebrew/opt/foo/Frameworks` |
| **`kext_prefix`**     | `#{prefix}/Library/Extensions`                 | `/opt/homebrew/Cellar/foo/0.1/Library/Extensions` |
| **`bash_completion`** | `#{prefix}/etc/bash_completion.d`              | `/opt/homebrew/Cellar/foo/0.1/etc/bash_completion.d` |
| **`fish_completion`** | `#{prefix}/share/fish/vendor_completions.d`    | `/opt/homebrew/Cellar/foo/0.1/share/fish/vendor_completions.d` |
| **`fish_function`**   | `#{prefix}/share/fish/vendor_functions.d`      | `/opt/homebrew/Cellar/foo/0.1/share/fish/vendor_functions.d` |
| **`zsh_completion`**  | `#{prefix}/share/zsh/site-functions`           | `/opt/homebrew/Cellar/foo/0.1/share/zsh/site-functions` |
| **`zsh_function`**    | `#{prefix}/share/zsh/site-functions`           | `/opt/homebrew/Cellar/foo/0.1/share/zsh/site-functions` |
| **`pwsh_completion`** | `#{prefix}/share/pwsh/completions`             | `/opt/homebrew/Cellar/foo/0.1/share/pwsh/completions` |
| **`buildpath`**       | temporary working directory during builds      | `/private/tmp/foo-20250205-69197-po5981/foo-0.1` |
| **`testpath`**        | temporary working directory during tests       | `/private/tmp/foo-test-20250205-84567-4hfs9m` |

These can be used, for instance, in code such as:

```ruby
bin.install Dir["output/*"]
```

to move binaries into their correct location within the Cellar, and:

```ruby
man.mkpath
```

to create the directory structure for the manual page location.

To install man pages into specific locations, use `man1.install "foo.1", "bar.1"`, `man2.install "foo.2"`, etc.

The `opt_` variants generate paths that are stable between updates, which can be useful for e.g. replacing versioned paths in files:

```ruby
inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
```

Note that in the context of Homebrew, [`libexec`](/rubydoc/Formula.html#libexec-instance_method) is reserved for private use by the formula and therefore is not symlinked into `HOMEBREW_PREFIX`.

### File-level operations

You can use the file utilities provided by Ruby's [`FileUtils`](https://ruby-doc.org/current/stdlibs/fileutils/FileUtils.html). These are included in the [`Formula` class](/rubydoc/Formula.html), so you do not need the `FileUtils.` prefix to use them.

When creating symlinks, take special care to ensure they are *relative* symlinks. This makes it easier to create a relocatable bottle. For example, to create a symlink in `bin` to an executable in `libexec`, use:

```ruby
bin.install_symlink libexec/"name"
```

instead of:

```ruby
ln_s libexec/"name", bin
```

The symlinks created by [`install_symlink`](/rubydoc/Pathname.html#install_symlink-instance_method) are guaranteed to be relative. `ln_s` will only produce a relative symlink when given a relative path.

Several other utilities for Ruby's [`Pathname`](/rubydoc/Pathname.html) can simplify some common operations.

* To perform several operations within a directory, enclose them within a  [`cd <path> do`](/rubydoc/Pathname.html#cd-instance_method) block:

```ruby
cd "src" do
  system "./configure", "--disable-debug", "--prefix=#{prefix}"
  system "make", "install"
end
```

* To surface one or more binaries buried in `libexec` or a macOS `.app` package, use [`write_exec_script`](/rubydoc/Pathname.html#write_exec_script-instance_method) or [`write_jar_script`](/rubydoc/Pathname.html#write_jar_script-instance_method):

```ruby
bin.write_exec_script Dir[libexec/"bin/*"]
bin.write_exec_script prefix/"Package.app/Contents/MacOS/package"
bin.write_jar_script libexec/jar_file, "jarfile", java_version: "11"
```

* For binaries that require setting one or more environment variables to function properly, use [`write_env_script`](/rubydoc/Pathname.html#write_env_script-instance_method) or [`env_script_all_files`](/rubydoc/Pathname.html#env_script_all_files-instance_method):

```ruby
(bin/"package").write_env_script libexec/"package", PACKAGE_ROOT: libexec
bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV.fetch("PERL5LIB", nil))
```

### Rewriting a script shebang

Some formulae install executable scripts written in an interpreted language such as Python or Perl. Homebrew provides a `rewrite_shebang` method to rewrite the shebang of a script. This replaces a script's original interpreter path with the one the formula depends on. This guarantees that the correct interpreter is used at execution time. This isn't required if the build system already handles it (e.g. often with `pip` or Perl `ExtUtils::MakeMaker`).

For example, the [`icdiff`](https://github.com/Homebrew/homebrew-core/blob/bc311e91f3a77889e568dec8d3063c3a6cb2965a/Formula/i/icdiff.rb#L18) formula uses this utility. Note that it is necessary to include the utility in the formula; for example with Python one must use `include Language::Python::Shebang`.

### Adding optional steps

**Note:** [`option`](/rubydoc/Formula.html#option-class_method)s are not allowed in Homebrew/homebrew-core as they are not tested by CI.

If you want to add an [`option`](/rubydoc/Formula.html#option-class_method):

```ruby
class Yourformula < Formula
  # ...
  url "https://example.com/yourformula-1.0.tar.gz"
  sha256 "abc123abc123abc123abc123abc123abc123abc123abc123abc123abc123abc1"
  # ...
  option "with-ham", "Description of the option"
  option "without-spam", "Another description"

  depends_on "bar" => :recommended
  depends_on "foo" => :optional # automatically adds a with-foo option # automatically adds a without-bar option
  # ...
end
```

And then to define the effects the [`option`](/rubydoc/Formula.html#option-class_method)s have:

```ruby
if build.with? "ham"
  # note, no "with" in the option name (it is added by the build.with? method)
end

if build.without? "ham"
  # works as you'd expect. True if `--without-ham` was given.
end
```

[`option`](/rubydoc/Formula.html#option-class_method) names should be prefixed with the words `with` or `without`. For example, an option to run a test suite should be named `--with-test` or `--with-check` rather than `--test`, and an option to enable a shared library `--with-shared` rather than `--shared` or `--enable-shared`. See the [alternative `ffmpeg`](https://github.com/homebrew-ffmpeg/homebrew-ffmpeg/blob/HEAD/Formula/ffmpeg.rb) formula for examples.

[`option`](/rubydoc/Formula.html#option-class_method)s that aren’t `build.with?` or `build.without?` should be deprecated with [`deprecated_option`](/rubydoc/Formula.html#deprecated_option-class_method). See the [`wget`](https://github.com/Homebrew/homebrew-core/blob/3f762b63c6fbbd49191ffdf58574d7e18937d93f/Formula/wget.rb#L27-L31) formula for a historical example.

### Running commands after installation

Any initialization steps that aren't necessarily part of the install process can be located in a `post_install` block, such as setup commands or data directory creation. This block can be re-run separately with `brew postinstall <formula>`.

```ruby
class Foo < Formula
  # ...
  url "https://example.com/foo-1.0.tar.gz"

  def post_install
    rm pkgetc/"cert.pem" if File.exist?(pkgetc/"cert.pem")
    pkgetc.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end
  # ...
end
```

In the above example, the [`libressl`](https://github.com/Homebrew/homebrew-core/blob/442f9cc511ce6dfe75b96b2c83749d90dde914d2/Formula/lib/libressl.rb#L53-L56) formula replaces its stock list of certificates with a symlink to that of the `ca-certificates` formula.

### Handling files that should persist over formula upgrades

For example, Ruby 1.9’s gems should be installed to `var/lib/ruby/` so that gems don’t need to be reinstalled when upgrading Ruby. You can usually do this with symlink trickery, or (ideally) a configure option.

Another example would be configuration files that should not be overwritten on package upgrades. If after installation you find that to-be-persisted configuration files are not copied but instead *symlinked* into `$(brew --prefix)/etc/` from the Cellar, this can often be rectified by passing an appropriate argument to the package’s configure script. That argument will vary depending on a given package’s configure script and/or Makefile, but one example might be: `--sysconfdir=#{etc}`

### Service files

There are two ways to add `launchd` plists and `systemd` services to a formula, so that `brew services` can pick them up:

1. If the package already provides a service file the formula can reference it by name:

```ruby
service do
  name macos: "custom.launchd.name",
       linux: "custom.systemd.name"
end
```

   To find the file we append `.plist` to the `launchd` service name and `.service` to the `systemd` service name internally.

2. If the formula does not provide a service file you can generate one using the following stanza:

```ruby
# 1. An individual command
service do
  run opt_bin/"script"
end

# 2. A command with arguments
service do
  run [opt_bin/"script", "--config", etc/"dir/config.yml"]
end

# 3. OS specific commands (If you omit one, the service file won't get generated for that OS.)
service do
  run macos: [opt_bin/"macos_script", "standalone"],
      linux: var/"special_linux_script"
end
```

#### Service block methods

This table lists the options you can set within a `service` block. The `run` or `name` field must be defined inside the service block. If `name` is defined without `run`, then Homebrew makes no attempt to change the package-provided service file according these fields. The `run` field indicates what command to run, instructs Homebrew to create a service description file using options set in the block, and therefore is required before using fields other than `name` and `require_root`.

| method                  | default      | macOS | Linux | description |
| ----------------------- | ------------ | :---: | :---: | ----------- |
| `run`                   | -            |  yes  |  yes  | command to execute: an array with arguments or a path |
| `run_type`              | `:immediate` |  yes  |  yes  | type of service: `:immediate`, `:interval` or `:cron` |
| `interval`              | -            |  yes  |  yes  | controls the start interval, required for the `:interval` type |
| `cron`                  | -            |  yes  |  yes  | controls the trigger times, required for the `:cron` type |
| `keep_alive`            | `false`      |  yes  |  yes  | [sets contexts](#keep_alive-options) in which the service will keep the process running |
| `launch_only_once`      | `false`      |  yes  |  yes  | whether the command should only run once |
| `require_root`          | `false`      |  yes  |  yes  | whether the service requires root access. If true, Homebrew hints at using `sudo` on various occasions, but does not enforce it |
| `environment_variables` | -            |  yes  |  yes  | hash of variables to set |
| `working_dir`           | -            |  yes  |  yes  | directory to operate from |
| `root_dir`              | -            |  yes  |  yes  | directory to use as a chroot for the process |
| `input_path`            | -            |  yes  |  yes  | path to use as input for the process |
| `log_path`              | -            |  yes  |  yes  | path to write `stdout` to |
| `error_log_path`        | -            |  yes  |  yes  | path to write `stderr` to |
| `restart_delay`         | -            |  yes  |  yes  | number of seconds to delay before restarting a process |
| `process_type`          | -            |  yes  | no-op | type of process to manage: `:background`, `:standard`, `:interactive` or `:adaptive` |
| `macos_legacy_timers`   | -            |  yes  | no-op | timers created by `launchd` jobs are coalesced unless this is set |
| `sockets`               | -            |  yes  | no-op | socket that is created as an accesspoint to the service |
| `name`                  | -            |  yes  |  yes  | a hash with the `launchd` service name on macOS and/or the `systemd` service name on Linux. Homebrew generates a default name for the service file if this is not present |

For services that are kept alive after starting you can use the default `run_type`:

```ruby
service do
  run [opt_bin/"beanstalkd", "test"]
  keep_alive true
  run_type :immediate # This should be omitted since it's the default
end
```

If a service needs to run on an interval, use `run_type :interval` and specify an interval:

```ruby
service do
  run [opt_bin/"beanstalkd", "test"]
  run_type :interval
  interval 500
end
```

If a service needs to run at certain times, use `run_type :cron` and specify a time with the crontab syntax:

```ruby
service do
  run [opt_bin/"beanstalkd", "test"]
  run_type :cron
  cron "5 * * * *"
end
```

Environment variables can be set with a hash. For the `PATH` there is the helper method `std_service_path_env` which returns `#{HOMEBREW_PREFIX}/bin:#{HOMEBREW_PREFIX}/sbin:/usr/bin:/bin:/usr/sbin:/sbin` so the service can find other `brew`-installed commands.

```ruby
service do
  run opt_bin/"beanstalkd"
  environment_variables PATH: std_service_path_env
end
```

#### `keep_alive` options

The standard options keep the service alive regardless of any status or circumstances:

```ruby
service do
  run [opt_bin/"beanstalkd", "test"]
  keep_alive true # or false
end
```

Same as above in hash form:

```ruby
service do
  run [opt_bin/"beanstalkd", "test"]
  keep_alive always: true
end
```

Keep alive until the service exits with a non-zero return code:

```ruby
service do
  run [opt_bin/"beanstalkd", "test"]
  keep_alive successful_exit: true
end
```

Keep alive only if the job crashed:

```ruby
service do
  run [opt_bin/"beanstalkd", "test"]
  keep_alive crashed: true
end
```

Keep alive as long as a file exists:

```ruby
service do
  run [opt_bin/"beanstalkd", "test"]
  keep_alive path: "/some/path"
end
```

#### `sockets` format

The `sockets` method accepts a formatted socket definition as `<type>://<host>:<port>`.

* `type`: `udp` or `tcp`
* `host`: host to run the socket on, e.g. `0.0.0.0`
* `port`: port number the socket should listen on

Please note that sockets will be accessible on IPv4 and IPv6 addresses by default.

If you only need one socket and you don't care about the name (the default is `listeners`):

```rb
service do
  run [opt_bin/"beanstalkd", "test"]
  sockets "tcp://127.0.0.1:80"
end
```

If you need multiple sockets and/or you want to specify the name:

```rb
service do
  run [opt_bin/"beanstalkd", "test"]
  sockets http: "tcp://0.0.0.0:80", https: "tcp://0.0.0.0:443"
end
```

### Using environment variables

Homebrew has multiple levels of environment variable filtering which affects which variables are available to formulae.

Firstly, the overall [environment in which Homebrew runs is filtered](https://github.com/Homebrew/brew/issues/932) to avoid environment contamination breaking from-source builds. In particular, this process filters all but a select list of variables, plus allowing any prefixed with `HOMEBREW_`. The specific implementation is found in [`bin/brew`](https://github.com/Homebrew/brew/blob/HEAD/bin/brew).

The second level of filtering [removes sensitive environment variables](https://github.com/Homebrew/brew/pull/2524) (such as credentials like keys, passwords or tokens) to prevent malicious subprocesses from obtaining them. This has the effect of preventing any such variables from reaching a formula's Ruby code since they are filtered before it is called. The specific implementation is found in the [`ENV.clear_sensitive_environment!` method](https://github.com/Homebrew/brew/blob/HEAD/Library/Homebrew/extend/ENV.rb).

In summary, any environment variables intended for use by a formula need to conform to these filtering rules in order to be available.

#### Setting environment variables during installation

You can set environment variables in a formula's `install` or `test` blocks using `ENV["VARIABLE_NAME"] = "VALUE"`. An example can be seen in the [`csound`](https://github.com/Homebrew/homebrew-core/blob/442f9cc511ce6dfe75b96b2c83749d90dde914d2/Formula/c/csound.rb#L96) formula.

Environment variables can also be set temporarily using the `with_env` method; any variables defined in the call to that method will be restored to their original values at the end of the block. An example can be seen in the [`gh`](https://github.com/Homebrew/homebrew-core/blob/1fd795861004bdf8bc5f6687c58b76c674794d40/Formula/g/gh.rb#L28-L33) formula.

There are also `ENV` helper methods available for many common environment variable setting and retrieval operations, such as:

* `ENV.cxx11` - compile with C++11 features enabled
* `ENV.deparallelize` - compile with only one job at a time; pass a block to have it only influence specific install steps
* `ENV.O0`, `ENV.O1`, `ENV.O3` - set a specific compiler optimization level (*default:* macOS: `-Os`, Linux: `-O2`)
* `ENV.runtime_cpu_detection` - account for formulae that detect CPU features at runtime
* `ENV.append_to_cflags` - add a value to `CFLAGS` `CXXFLAGS` `OBJCFLAGS` `OBJCXXFLAGS` all at once
* `ENV.prepend_create_path` - create and prepend a path to an existing list of paths
* `ENV.remove` - remove a string from an environment variable value
* `ENV.delete` - unset an environment variable

The full list can be found in the [`SharedEnvExtension` module](/rubydoc/SharedEnvExtension.html) and [`Superenv` module](/rubydoc/Superenv.html) documentation.

### Deprecating and disabling a formula

See our [Deprecating, Disabling and Removing Formulae](Deprecating-Disabling-and-Removing-Formulae.md) documentation for more information about how and when to deprecate or disable a formula.

## Updating formulae

When a new version of the software is released, use `brew bump-formula-pr` to automatically update the [`url`](/rubydoc/Formula.html#url-class_method) and [`sha256`](/rubydoc/Formula.html#sha256-class_method), remove any [`revision`](/rubydoc/Formula.html#revision-class_method) lines, and submit a pull request. See our [How to Open a Homebrew Pull Request](How-To-Open-a-Homebrew-Pull-Request.md) documentation for more information.

## Troubleshooting for new formulae

### Version detection failures

Homebrew tries to automatically determine the [`version`](/rubydoc/Formula.html#version-class_method) from the [`url`](/rubydoc/Formula.html#url-class_method) to avoid duplication. If the tarball has an unusual name you may need to manually assign the [`version`](/rubydoc/Formula.html#version-class_method).

### Bad makefiles

If a project's makefile will not run in parallel, try to deparallelize by adding these lines to the formula's `install` method:

```ruby
ENV.deparallelize
system "make" # separate compilation and installation steps
system "make", "install"
```

If that fixes it, please open an issue with the upstream project so that we can fix it for everyone.

### Still won’t work?

Check out what MacPorts and Fink do:

```sh
brew search --macports foo
brew search --fink foo
```

### Superenv notes

`superenv` is our "super environment" that isolates builds by removing `/usr/local/bin` and all user `PATH`s that are not essential for the build. It does this because user `PATH`s are often full of stuff that breaks builds. `superenv` also removes bad flags from the commands passed to `clang`/`gcc` and injects others (for example all [`keg_only`](/rubydoc/Formula.html#keg_only-class_method) dependencies are added to the `-I` and `-L` flags).

If in your local Homebrew build of your new formula, you see `Operation not permitted` errors, this will be because your new formula tried to write to the disk outside of your sandbox area. This is enforced on macOS by `sandbox-exec`.

### Fortran

Some software requires a Fortran compiler. This can be declared by adding `depends_on "gcc"` to a formula.

### MPI

Packages requiring MPI should use [OpenMPI](https://www.open-mpi.org/) by adding `depends_on "open-mpi"` to the formula, rather than [MPICH](https://www.mpich.org/). These packages have conflicts and provide the same standardised interfaces. Choosing a default implementation and requiring its adoption allows software to link against multiple libraries that rely on MPI without creating unanticipated incompatibilities due to differing MPI runtimes.

### Linear algebra libraries

Packages requiring BLAS/LAPACK linear algebra interfaces should link to [OpenBLAS](https://www.openblas.net/) by adding `depends_on "openblas"` and (if built with CMake) passing `-DBLA_VENDOR=OpenBLAS` to CMake, rather than Apple's Accelerate framework or the default reference `lapack` implementation. Apple's implementation of BLAS/LAPACK is outdated and may introduce hard-to-debug problems. The reference `lapack` formula is fine, although it is not actively maintained or tuned.

## How to start over (reset to upstream)

Have you created a real mess in Git which stops you from creating a commit you want to submit to us? You might want to consider starting again from scratch. Your changes to the Homebrew `main` branch can be reset by running:

```sh
git checkout -f main
git reset --hard origin/HEAD
```
---
last_review_date: "2025-02-08"
---

# Migrating a Formula to a Tap

There are times when we may wish to migrate a formula from one tap into another tap. To do this:

1. Create a pull request on the new tap adding the formula file as-is from the original tap. Fix any test failures that may occur due to the stricter requirements for new formulae compared to existing formulae (e.g. `brew audit --strict` must pass for that formula).
2. Create a pull request on the original tap deleting the formula file and adding it to `tap_migrations.json` with a commit message like `gv: migrate to homebrew/core`.
3. Put a link for each pull request in the other pull request so the maintainers can merge them both at once.

Congratulations, you've moved a formula to another tap!

For Homebrew maintainers, formulae should only ever be migrated into and within the Homebrew organisation (e.g. from `homebrew/core` to `homebrew/cask`, or from a third-party tap to `homebrew/core`), and never out of it.
---
last_review_date: "1970-01-01"
---

# Node for Formula Authors

This document explains how to successfully use Node and npm in a Node module based Homebrew formula.

## Running `npm install`

Homebrew provides a helper method `std_npm_args` to set up the correct environment for npm and return arguments for `npm install`. Your formula should use this when invoking `npm install`. The syntax for a standard Node module installation is:

```ruby
system "npm", "install", *std_npm_args
```

## Download URL

If the Node module is also available on the npm registry, we prefer npm-hosted release tarballs over GitHub (or elsewhere) hosted source tarballs. The advantages of these tarballs are that they don't include the files from the `.npmignore` (such as tests) resulting in a smaller download size and that any possible transpilation step is already done (e.g. no need to compile CoffeeScript files as a build step).

The npm registry URLs usually have the format of:

    https://registry.npmjs.org/<name>/-/<name>-<version>.tgz

Alternatively you could `curl` the JSON at `https://registry.npmjs.org/<name>` and look for the value of `versions[<version>].dist.tarball` for the correct tarball URL.

## Dependencies

Node modules which are compatible with the latest Node version should declare a dependency on the `node` formula.

```ruby
depends_on "node"
```

If your formula requires being executed with an older Node version you should use one of its versioned formulae (e.g. `node@20`).

### Special requirements for native addons

If your Node module is a native addon or has a native addon somewhere in its dependency tree you have to declare an additional dependency. Since the compilation of the native addon results in an invocation of `node-gyp` we need an additional build time dependency on `"python"` (because GYP depends on Python).

```ruby
depends_on "python" => :build
```

Also note that such a formula would only be compatible with the same Node major version it originally was compiled with. This means that we need to revision every formula with a Node native addon with every major version bump of the `node` formula. To make sure we don't overlook your formula on a Node major version bump, write a meaningful test which would fail in such a case (being invoked with an ABI-incompatible Node version).

## Installation

Node modules should be installed to `libexec`. This prevents the Node modules from contaminating the global `node_modules`, which is important so that npm doesn't try to manage Homebrew-installed Node modules.

In the following we distinguish between two types of Node modules installed using formulae:

- formulae for standard Node modules compatible with npm's global module format which should use [`std_npm_args`](#installing-global-style-modules-with-std_npm_args-to-libexec) (like [`angular-cli`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/a/angular-cli.rb) or [`webpack`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/w/webpack.rb))
- formulae where the `npm install` call is not the only required install step (e.g. need to also compile non-JavaScript sources) which have to use [`std_npm_args`](#installing-module-dependencies-locally-with-std_npm_args) (like [`emscripten`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/e/emscripten.rb) or [`grunt-cli`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/g/grunt-cli.rb))

What both methods have in common is that they are setting the correct environment for using npm inside Homebrew and are returning the arguments for invoking `npm install` for their specific use cases. This includes fixing an important edge case with the npm cache (caused by Homebrew's redirection of `HOME` during the build and test process) by using our own custom `npm_cache` inside `HOMEBREW_CACHE`, which would otherwise result in very long build times and high disk space usage.

### Installing global style modules with `std_npm_args` to `libexec`

In your formula's `install` method, simply `cd` to the top level of your Node module if necessary and then use `system` to invoke `npm install` with `std_npm_args` like:

```ruby
system "npm", "install", *std_npm_args
```

This will install your Node module in npm's global module style with a custom prefix to `libexec`. All your modules' executables will be automatically resolved by npm into `libexec/bin` for you, which are not symlinked into Homebrew's prefix. To make sure these are installed, we need to symlink all executables to `bin` with:

```ruby
bin.install_symlink Dir["#{libexec}/bin/*"]
```

### Installing module dependencies locally with `std_npm_args`

In your formula's `install` method, do any installation steps which need to be done before the `npm install` step and then `cd` to the top level of the included Node module. Then, use `system` to invoke `npm install` with `std_npm_args(prefix: false)` like:

```ruby
system "npm", "install", *std_npm_args(prefix: false)
```

This will install all of your Node modules' dependencies to your local build path. You can now continue with your build steps and handle the installation into the Homebrew prefix on your own, following the [general Homebrew formula instructions](Formula-Cookbook.md).

## Example

Installing a standard Node module based formula would look like this:

```ruby
class Foo < Formula
  desc "An example formula"
  homepage "https://example.com"
  url "https://registry.npmjs.org/foo/-/foo-1.4.2.tgz"
  sha256 "abc123abc123abc123abc123abc123abc123abc123abc123abc123abc123abc1"

  depends_on "node"
  # uncomment if there is a native addon inside the dependency tree
  # depends_on "python" => :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # add a meaningful test here, version isn't usually meaningful
    assert_match version.to_s, shell_output("#{bin}/foo --version")
  end
end
```

## Tooling

You can use [homebrew-npm-noob](https://github.com/zmwangx/homebrew-npm-noob) to automatically generate a formula like the example above for an npm package.
---
last_review_date: "1970-01-01"
---

# Python for Formula Authors

This document explains how to successfully use Python in a Homebrew formula.

Homebrew draws a distinction between Python **applications** and Python **libraries**. The difference is that users generally do not care that applications are written in Python; it is unusual that a user would expect to be able to `import foo` after installing an application. Examples of applications are [`ansible`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/a/ansible.rb) and [`jrnl`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/j/jrnl.rb).

Python libraries exist to be imported by other Python modules; they are often dependencies of Python applications. They are usually no more than incidentally useful in a terminal. Examples of libraries are [`certifi`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/c/certifi.rb) and [`numpy`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/n/numpy.rb).

Bindings are a special case of libraries that allow Python code to interact with a library or application implemented in another language. An example is the Python bindings installed by [`libxml2`](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/lib/libxml2.rb).

Homebrew is happy to accept applications that are built in Python, whether the apps are available from PyPI or not. Homebrew generally won't accept libraries that can be installed correctly with `pip install foo`. Bindings may be installed for packages that provide them, especially if equivalent functionality isn't available through pip. Similarly, libraries that have non-trivial amounts of native code and have a long compilation as a result can be good candidates. If in doubt, though: do not package libraries.

Applications should unconditionally bundle all their Python-language dependencies and libraries and should install any unsatisfied dependencies; these strategies are discussed in depth in the following sections.

## Applications

### Python declarations for applications

Formulae for apps that require Python 3 **must** declare an unconditional dependency on `"python@3.y"`. These apps **must** work with the current Homebrew Python 3.y formula.

### Installing applications

Starting with Python@3.12, Homebrew follows [PEP 668](https://peps.python.org/pep-0668/#marking-an-interpreter-as-using-an-external-package-manager). Applications must be installed into a Python [virtual environment](https://docs.python.org/3/library/venv.html) rooted in `libexec`. This prevents the app's Python modules from contaminating the system `site-packages` and vice versa.

All the Python module dependencies of the application (and their dependencies, recursively) should be [declared as `resource`s](Formula-Cookbook.md#python-dependencies) in the formula and installed into the virtual environment as well. Each dependency should be explicitly specified; please do not rely on `setup.py` or `pip` to perform automatic dependency resolution, for the [reasons described here](Acceptable-Formulae.md#we-dont-like-install-scripts-that-download-unversioned-things).

You can use `brew update-python-resources` to help you write resource stanzas. To use it, simply run `brew update-python-resources <formula>`. Sometimes, `brew update-python-resources` won't be able to automatically update the resources. If this happens, try running `brew update-python-resources --print-only <formula>` to print the resource stanzas instead of applying the changes directly to the file. You can then copy and paste resources as needed.

If using `brew update-python-resources` doesn't work, you can use [homebrew-pypi-poet](https://github.com/tdsmith/homebrew-pypi-poet) to help you write resource stanzas. To use it, set up a virtual environment and install your package and all its dependencies. Then, `pip install homebrew-pypi-poet` into the same virtual environment. Running `poet some_package` will generate the necessary resource stanzas. You can do this like:

```sh
# Use a temporary directory for the virtual environment
cd "$(mktemp -d)"

# Create and source a new virtual environment in the venv/ directory
python3 -m venv venv
source venv/bin/activate

# Install the package of interest as well as homebrew-pypi-poet
pip install some_package homebrew-pypi-poet
poet some_package

# Destroy the virtual environment
deactivate
rm -rf venv
```

Homebrew provides helper methods for instantiating and populating virtual environments. You can use them by putting `include Language::Python::Virtualenv` at the top of the `Formula` class definition.

For most applications, all you will need to write is:

```ruby
class Foo < Formula
  include Language::Python::Virtualenv

  # ...
  url "https://example.com/foo-1.0.tar.gz"
  sha256 "abc123abc123abc123abc123abc123abc123abc123abc123abc123abc123abc1"

  depends_on "python@3.y"

  def install
    virtualenv_install_with_resources
  end
end
```

This is exactly the same as writing:

```ruby
class Foo < Formula
  include Language::Python::Virtualenv

  # ...
  url "https://example.com/foo-1.0.tar.gz"
  sha256 "abc123abc123abc123abc123abc123abc123abc123abc123abc123abc123abc1"

  depends_on "python@3.y"

  def install
    # Create a virtualenv in `libexec`.
    venv = virtualenv_create(libexec, "python3.y")
    # Install all of the resources declared on the formula into the virtualenv.
    venv.pip_install resources
    # `pip_install_and_link` takes a look at the virtualenv's bin directory
    # before and after installing its argument. New scripts will be symlinked
    # into `bin`. `pip_install_and_link buildpath` will install the package
    # that the formula points to, because buildpath is the location where the
    # formula's tarball was unpacked.
    venv.pip_install_and_link buildpath
  end
end
```

### Example formula

Installing a formula with dependencies will look like this:

```ruby
class Foo < Formula
  include Language::Python::Virtualenv

  desc "Description"
  homepage "https://example.com"
  url "..."

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  def install
    virtualenv_install_with_resources
  end
end
```

You can also use the more verbose form and request that specific resources be installed:

```ruby
class Foo < Formula
  include Language::Python::Virtualenv

  desc "Description"
  homepage "https://example.com"
  url "..."

  def install
    venv = virtualenv_create(libexec)
    %w[six parsedatetime].each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
  end
end
```

in case you need to do different things for different resources.

## Bindings

To add bindings for Python 3, please add `depends_on "python@3.y"` to work with the current Homebrew Python 3.y formula.

### Dependencies for bindings

Bindings should follow the same advice for Python module dependencies as libraries; see below for more.

### Installing bindings

If the bindings are installed by invoking a `setup.py`, do something like:

```ruby
system "python3.y", "-m", "pip", "install", *std_pip_args(build_isolation: true), "./source/python"
```

#### Autotools

If the configure script takes a `--with-python` flag, it usually will not need extra help finding Python. However, if there are multiple Python formulae in the dependency tree, it may need help finding the correct one.

If the `configure` and `make` scripts do not want to install into the Cellar, sometimes you can:

1. call `./configure --without-python` (or a similar named option)
1. call `pip` on the directory containing the Python bindings (as described above)

Sometimes we have to edit a `Makefile` on-the-fly to use our prefix for the Python bindings using Homebrew's [`inreplace`](Formula-Cookbook.md#inreplace) helper method.

#### CMake

If `cmake` finds a different Python than the direct dependency, sometimes you can help it find the correct Python by setting one of the following variables with the `-D` option:

* `Python3_EXECUTABLE` for the [`FindPython3`](https://cmake.org/cmake/help/latest/module/FindPython3.html) module
* `Python_EXECUTABLE` for the [`FindPython`](https://cmake.org/cmake/help/latest/module/FindPython.html) module
* `PYTHON_EXECUTABLE` for the [`FindPythonInterp`](https://cmake.org/cmake/help/latest/module/FindPythonInterp.html) module

#### Meson

As a side effect of Homebrew's symlink installation and the Python sysconfig patch, `meson` may be unable to automatically detect the Cellar directories to install Python bindings into. If the formula's `meson` build definition uses [`install_sources()`](https://mesonbuild.com/Python-module.html#install_sources) or similar methods, you can set `python.purelibdir` and/or `python.platlibdir` to override the default paths.

If `meson` finds a different Python than the direct dependency and the formula's `meson` option definition file does not provide a user-settable option, then you will need to check how the Python executable is being detected. A common approach is the [`find_installation()`](https://mesonbuild.com/Python-module.html#find_installation) method which will behave differently based on what the `name_or_path` argument is set to.

## Libraries

Remember: there are very limited cases for libraries (e.g. significant amounts of native code is compiled) so, if in doubt, do not package them.

**We do not use the `python-` prefix for these kinds of formulae!**

### Examples of allowed libraries in homebrew-core

* `numpy`, `scipy`: long build time, complex build process

* `cryptography`: builds with `rust`

* `certifi`: patched formula to allow any Python-based formulae to leverage the brewed CA certs (see <https://github.com/orgs/Homebrew/discussions/4691>).

### Python declarations for libraries

Libraries built for Python 3 must include `depends_on "python@3.y"`, which will bottle against Homebrew's Python 3.y.

### Installing libraries

Libraries may be installed to `libexec` and added to `sys.path` by writing a `.pth` file (named like "homebrew-foo.pth") to the `prefix` site-packages. This simplifies the ensuing drama if pip is accidentally used to upgrade a Homebrew-installed package and prevents the accumulation of stale `.pyc` files in Homebrew's site-packages.

Most formulae presently just install to `prefix`. Any stale `.pyc` files are handled by `brew cleanup`.

### Dependencies for libraries

Library dependencies must be installed so that they are importable. To minimise the potential for linking conflicts, dependencies should be installed to `libexec/<vendor>` and added to `sys.path` by writing a second `.pth` file (named like "homebrew-foo-dependencies.pth") to the `prefix` site-packages.

Formulae with general Python library dependencies (e.g. `setuptools`, `six`) should not use this approach as it will contaminate the system `site-packages` with all libraries installed inside `libexec/<vendor>`.

## Further down the rabbit hole

Additional commentary that explains why Homebrew does some of the things it does.

### Setuptools vs. Distutils vs. pip

Distutils was a module in the Python standard library that provided developers a basic package management API until its removal in Python 3.12. Setuptools is a module distributed outside the standard library that extends and replaces Distutils. It is a convention that Python packages provide a `setup.py` that calls the `setup()` function from either Distutils or Setuptools.

Setuptools used to provide the `easy_install` command, which was an end-user package management tool that fetched and installed packages from PyPI, the Python Package Index. The `easy_install` console script was removed in Setuptools v52.0.0 and direct usage has been deprecated since v58.3.0. `pip` is another, newer end-user package management tool, which is also provided outside the standard library. While `pip` supplants `easy_install`, it does not replace the other functionality of the Setuptools module.

Distutils and pip use a "flat" installation hierarchy that installs modules as individual files under `site-packages` while `easy_install` installs zipped eggs to `site-packages` instead.

Distribute (not to be confused with Distutils) is an obsolete fork of Setuptools. Distlib is a package maintained outside the standard library which is used by pip for some low-level packaging operations and is not relevant to most `setup.py` users.

### Running `setup.py`

For when a formula needs to interact with `setup.py` instead of calling `pip`, Homebrew provides the helper method `Language::Python.setup_install_args` which returns useful arguments for invoking `setup.py`. Your formula should use this instead of invoking `setup.py` explicitly. The syntax is:

```ruby
system Formula["python@3.y"].opt_bin/"python3.y", *Language::Python.setup_install_args(prefix)
```

where `prefix` is the destination prefix (usually `libexec` or `prefix`).

### What is `--single-version-externally-managed`?

`--single-version-externally-managed` ("SVEM") is a [Setuptools](https://setuptools.readthedocs.io/en/latest/setuptools.html)-only argument to `setup.py install`. The primary effect of SVEM is using Distutils to perform the install instead of Setuptools' `easy_install`.

`easy_install` does a few things that we need to avoid:

* fetches and installs dependencies
* upgrades dependencies in `sys.path` in-place
* writes `.pth` and `site.py` files which aren't useful for us and cause link conflicts

Setuptools requires that SVEM be used in conjunction with `--record`, which provides a list of files that can later be used to uninstall the package. We don't need or want this because Homebrew can manage uninstallation, but since Setuptools demands it we comply. The Homebrew convention is to name the record file "installed.txt".

Detecting whether a `setup.py` uses `setup()` from Setuptools or Distutils is difficult, but we always need to pass this flag to Setuptools-based scripts. `pip` faces the same problem that we do and forces `setup()` to use the Setuptools version by loading a shim around `setup.py` that imports Setuptools before doing anything else. Since Setuptools monkey-patches Distutils and replaces its `setup` function, this provides a single, consistent interface. We have borrowed this code and use it in `Language::Python.setup_install_args`.

### `--prefix` vs `--root`

`setup.py` accepts a slightly bewildering array of installation options. The correct switch for Homebrew is `--prefix`, which automatically sets the `--install-foo` family of options with sane POSIX-y values.

`--root` [is used](https://mail.python.org/pipermail/distutils-sig/2010-November/017099.html) when installing into a prefix that will not become part of the final installation location of the files, like when building a RPM or binary distribution. When using a `setup.py`-based Setuptools, `--root` has the side effect of activating `--single-version-externally-managed`. It is not safe to use `--root` with an empty `--prefix` because the `root` is removed from paths when byte-compiling modules.

It is probably safe to use `--prefix` with `--root=/`, which should work with either Setuptools- or Distutils-based `setup.py`'s, but it's kinda ugly.

### `pip` vs. `setup.py`

[PEP 453](https://legacy.python.org/dev/peps/pep-0453/#recommendations-for-downstream-distributors) makes a recommendation to downstream distributors (us) that sdist tarballs should be installed with `pip` instead of by invoking `setup.py` directly. For historical reasons we did not follow PEP 453, so some formulae still use `setup.py` installs. Nowadays, most core formulae use `pip` as we have migrated them to this preferred method of installation.
---
last_review_date: "1970-01-01"
---

# Renaming a Formula

Sometimes software and formulae need to be renamed. To rename a formula you need to:

1. Rename the formula file and its class to a new formula name. The new name must meet all the usual rules of formula naming. Fix any test failures that may occur due to the stricter requirements for new formulae compared to existing formulae (e.g. `brew audit --strict` must pass for that formula).

2. Create a pull request on the corresponding tap deleting the old formula file, adding the new formula file, and adding it to `formula_renames.json` with a commit message like `newack: renamed from ack`. Use the canonical name (e.g. `ack` instead of `user/repo/ack`).

A `formula_renames.json` example for a formula rename:

```json
{
  "ack": "newack"
}
```
