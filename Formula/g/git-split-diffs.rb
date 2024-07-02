require "language/node"

class GitSplitDiffs < Formula
  desc "Syntax highlighted side-by-side diffs in your terminal"
  homepage "https://github.com/banga/git-split-diffs"
  url "https://registry.npmjs.org/git-split-diffs/-/git-split-diffs-2.0.0.tgz"
  sha256 "4fc81103a28728fb1925e1122967837c89aca5fd09fb6fb51c059066ee406d37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be2e89b1abb0ddc889f3f545094794151e9368afe0df468b79498c2edf88c39d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be2e89b1abb0ddc889f3f545094794151e9368afe0df468b79498c2edf88c39d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be2e89b1abb0ddc889f3f545094794151e9368afe0df468b79498c2edf88c39d"
    sha256 cellar: :any_skip_relocation, sonoma:         "be2e89b1abb0ddc889f3f545094794151e9368afe0df468b79498c2edf88c39d"
    sha256 cellar: :any_skip_relocation, ventura:        "be2e89b1abb0ddc889f3f545094794151e9368afe0df468b79498c2edf88c39d"
    sha256 cellar: :any_skip_relocation, monterey:       "be2e89b1abb0ddc889f3f545094794151e9368afe0df468b79498c2edf88c39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b98d38accb79c026d9641380afd10c17cb587a93429a8c1a99cb21685554cde"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "commit", "-m", "Second commit"

    system "git", "config", "--global", "core.pager", "git-split-diffs --color | less -RFX"

    assert_match "bar", shell_output("git diff HEAD^1...HEAD")
  end
end
