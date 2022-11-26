class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/63/41/6a7023cd87a7c811d1e7be6b31173c8f825c58b033c378d435d445f42f3f/git-delete-merged-branches-7.2.1.tar.gz"
  sha256 "6a17bf96e88fadf395fa0a079e9ff621f9aeb07c45ada16c61611353a1c2b90a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c1ea7e30ccd4b52c7da6a2f4f3cc59658bb404084415fa07def27cf7a016475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "434ef9a7920c473e1e1b912097dbefbc43d88f70ad2212593dee0dbfd2fb8c2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4154a0905d91d3654adccbbbe7a1ed46b52951dbde67c52e13183e90334d383"
    sha256 cellar: :any_skip_relocation, monterey:       "c829201f3be8793d8fbc090cced40c81a5482d1809139983144a42865c5dbb2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb749fd64390912b820f360664582f8efb3e13970fc1df3f5d1a96c3e2c9c8ec"
    sha256 cellar: :any_skip_relocation, catalina:       "30307e8c38c2908192017c1e5beaf3a912a09fedaa1fa447f0620b39f201394d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b62ce8cd33df2a038d82b101af386e0334bdb9e9e7962e1499820badd4c5a69"
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
