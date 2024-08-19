class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/60/09/917d48f0b931475bf3f3a60c522db12db05411ea028cae2adcb8482e2334/git_delete_merged_branches-7.4.1.tar.gz"
  sha256 "81ca59d29f3d555c1c4885384f5be33b2a1e637bb8e01f64a8605e9a5f6db6bb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "730fe878bf84f3f1686997cbfc6282e3cfaa12800ede068169aa98afb9e38942"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62de11e672702ebf784d738bc87a9acda1b2e678ba4fe2caad50c3592d5da8c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e58af7faeb41355b1f3c79b1516b6badd8f5cf461ba5c7c4fca982dd913ca45"
    sha256 cellar: :any_skip_relocation, sonoma:         "82dc490bab03da709570a42f0ff41dd0228f279add3e08914638f9d1441090a0"
    sha256 cellar: :any_skip_relocation, ventura:        "0fc90ecfaee427012ed2babd8c60a866f72e0ab495927deb7d53d23d827ebc4e"
    sha256 cellar: :any_skip_relocation, monterey:       "5e70e60ff0b865f882d6e7490b668ba7c9c1ad75579a946e8581e085517b4dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71b1113ce036b61fcfef91135d4ac3275699eb3b026aa4dda3bef714c5f32551"
  end

  depends_on "python@3.12"

  conflicts_with "git-extras", because: "both install `git-delete-merged-branches` binaries"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    origin = testpath/"origin"
    origin.mkdir
    clone = testpath/"clone"

    cd origin do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@example.com"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"
    end

    system "git", "clone", origin, clone

    cd clone do
      system "git", "config", "remote.origin.dmb-enabled", "true"
      system "git", "config", "branch.master.dmb-required", "true"
      system "git", "config", "delete-merged-branches.configured", "5.0.0+"
      system "git", "checkout", "-b", "new-branch"
      system "git", "checkout", "-"
      system "git", "delete-merged-branches", "--yes"
      branches = shell_output("git branch").split("\n")
      assert_equal 1, branches.length
    end
  end
end
