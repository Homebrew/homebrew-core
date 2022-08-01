class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/61/2e/9c15363d21e85b91d1c6dc4253b2ae0d6d5a77a140474a3969a239786d49/git-delete-merged-branches-7.0.0.tar.gz"
  sha256 "0ac1a543e4c5b585339c77d3abb14236516637a143e5e1ecc24f9b2ee2123433"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0165b8baf45dd618c90835c49dc520c82046b229da30bcf406e41c0e6a7d7911"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc9e624d56ac24b11c8872c55de72613e927f45c7c1c1015017ea32e7ac59647"
    sha256 cellar: :any_skip_relocation, monterey:       "6db55bdc66844d2366c4d87028d3f11016f3553bc0103593e4821baef4a868af"
    sha256 cellar: :any_skip_relocation, big_sur:        "72c138e2071af49e1076d4b5935f9b4941df7c7c0f757c1749799c0dffed1d80"
    sha256 cellar: :any_skip_relocation, catalina:       "4e643a6ac1e2f6e932f74cc083eaed60f1544fb7fdd2310643db72320e2a9f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e941c486cdd05ec92c3b672020f0e4b6f4f114c02b6e97dc66730a3828c734"
  end

  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c5/7e/71693dc21d20464e4cd7c600f2d8fad1159601a42ed55566500272fe69b5/prompt_toolkit-3.0.30.tar.gz"
    sha256 "859b283c50bde45f5f97829f77a4674d1c1fcd88539364f1b28a37805cfd89c0"
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
      system "git", "init"
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
