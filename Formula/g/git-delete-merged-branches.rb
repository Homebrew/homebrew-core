class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/38/c8/da076635e5b5002b8bb5c47add8c91e0e1a96f3e0bfa5772b75782388962/git_delete_merged_branches-7.7.0.tar.gz"
  sha256 "56b539a72fe856014a0ca0ab1430d612285fd8dd54fff67e1350bb37431cc264"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3be33f56aa1a810e2acd2af9f167bc45ccace4de9d82be49ef9d56ed9c68c8ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e49484beb977c01039ede0acfe52b41e52f7070d57b741a570761beee76dd030"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8cbdd496861d1800b00353183ba20a6c63f6e66ac7249051ca82f25c455128f"
    sha256 cellar: :any,                 arm64_linux:       "e5c25528cf9709f16b1db8b63589a27285f577c9c99cff96e26c4f4edf03c2ea"
    sha256 cellar: :any,                 x86_64_linux:      "d7d2941dd363f3a33722424a67aa60c747fd38c7b33c993a999761016b088540"
  end

  depends_on "python@3.15"

  conflicts_with "git-extras", because: "both install `git-delete-merged-branches` binaries"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    origin = testpath/"origin"
    origin.mkdir
    clone = testpath/"clone"

    cd origin do
      system "git", "init", "--initial-branch", "master"
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
