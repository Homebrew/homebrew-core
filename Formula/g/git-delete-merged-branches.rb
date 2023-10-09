class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/69/e1/377ded5fd14801bd7f3174ab429882d85086e34fe0a0eec308c160c803f4/git-delete-merged-branches-7.4.0.tar.gz"
  sha256 "b976b7b2210a1dab728e654e1b023f8e5309d98dc14730bfb613e893604847e5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3752fa27f6c46d580d98c2d24228fd5685629fec778a1f1d82e03e9308b7aea4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32a55097c34e9df80eb06db35a8282834cecab1b976815997f4c5ad5823b9517"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c4c3e401baa24ecf07d031ac6031920508e8eb0dee82f675f509378e7fbc203"
    sha256 cellar: :any_skip_relocation, sonoma:         "c768fb1021ad94916518b18842d1483ed470794d2dbc8b39697f73db100be0df"
    sha256 cellar: :any_skip_relocation, ventura:        "b79be0099c5dae02d3a867b26723dcc719bda2052a120968e2a5007a1d674a94"
    sha256 cellar: :any_skip_relocation, monterey:       "618cf5607d3e2529d07746eade8ab5109b4a312cb675b1c815a6926c94b1d375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1979eb7353922d1985d55ec9dd94b8e2291ebe63661d72e75be77902bf30ba6"
  end

  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
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
