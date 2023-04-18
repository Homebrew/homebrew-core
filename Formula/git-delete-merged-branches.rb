class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/69/e1/377ded5fd14801bd7f3174ab429882d85086e34fe0a0eec308c160c803f4/git-delete-merged-branches-7.4.0.tar.gz"
  sha256 "b976b7b2210a1dab728e654e1b023f8e5309d98dc14730bfb613e893604847e5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1f4cadd23d7ae986e1cd277b4671285c5cb9d37b82a56cf5d5bded60c2c66dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ba8bdbfd1e8a48055f4ccf9c80555f30493b81d22275ea8c6f1f068aea5993b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ee73deb52b0d188264da540f96117a68ec47a23b5d48bcff443a30051fe1fd3"
    sha256 cellar: :any_skip_relocation, ventura:        "32b93603171ff630752789326d73133cfd34d82992d441adbc24fb8141ff3919"
    sha256 cellar: :any_skip_relocation, monterey:       "b03b8a74a640775cad3e87ae9f57b78f3e9fc25d369fa52997edfc3e6614a53b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d03ae011563b36c9bb3a21b0d409de1c93d17b2e064fdb217edf46604bb34104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d1a952e80df638527282ce31225320e9300227fcfacbbf8ba36135cdab8441"
  end

  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
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
