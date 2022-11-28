class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/bd/ed/7bbaf651cd46c184c44b4885b1b8d4030b5c56576f481a05e577085d937a/git-delete-merged-branches-7.2.2.tar.gz"
  sha256 "d3111e745ef0c1db037ce8de5bc074b366641e30fa5454e7eaf551a08662241d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f7297e41261d0277fe131337dfb943737651634767253814d48e8d9f31e5c0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0bfee7bf18c43589beb85d07f13a0bc481cb665bdf3ebb8f7dba1c629efc621"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32fe2070aeb49c6bbddd0e17da3a44c552c9aaa526e22fd326b24359a8fb9155"
    sha256 cellar: :any_skip_relocation, monterey:       "86173fe4af11267554c59941f0dd5fbb5d9c2968b405b887a8ba7e7d89ef5bc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "86193e2e60eff2f70b5d51476769699092c8812f700758e848ffddc324c9313d"
    sha256 cellar: :any_skip_relocation, catalina:       "60acb23601308e0d273439a030fcfa1901b5fb06d7207bd68fe0959b77243848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a10ac453d5b9afd54ae3dcc33188d25c3858014c2d12e6a08e1fdbcb40a64a5"
  end

  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c4/6e/6ff7938f47981305a801a4c5b8d8ed282b58a28c01c394d43c1fbcfc810b/prompt_toolkit-3.0.33.tar.gz"
    sha256 "535c29c31216c77302877d5120aef6c94ff573748a5b5ca5b1b1f76f5e700c73"
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
