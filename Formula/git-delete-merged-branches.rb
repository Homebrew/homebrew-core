class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/86/e1/3a92a5b45c72456804cf7bc3c5f6d1b231d4a65c6cc3c6dc4b91e6ba4a5d/git-delete-merged-branches-7.2.0.tar.gz"
  sha256 "52c596569894481e7532d28dffbb7243547dfe3c13e6423eef18675e01b956a6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2a8eaabdb729c8ffdc14497839c28274938aad942a21d346ed1a3e29862191e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94803cd84f138892f268a07874ec2bf6d0bc1c7e555bb6b6284b060a4a9b55d3"
    sha256 cellar: :any_skip_relocation, monterey:       "2f0487dfe63caec0de7e243dd138a1b44bd90819df5d21c415cb295b0e3a0f97"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9bc9080ae37b1e9e621e226710e3ff267c7918a68ef8874c2037fcf8f3d7d75"
    sha256 cellar: :any_skip_relocation, catalina:       "b978c645c515f74200d42372ce06b4b202b8aa1922dc38ab4ce86a3c783adb72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0779059170dc859504e3ba382a97bd3f3c998c16bdfa9b0f06be78fafccfb061"
  end

  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/e2/d9/1009dbb3811fee624af34df9f460f92b51edac528af316eb5770f9fbd2e1/prompt_toolkit-3.0.32.tar.gz"
    sha256 "e7f2129cba4ff3b3656bbdda0e74ee00d2f874a8bcdb9dd16f5fec7b3e173cae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
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
