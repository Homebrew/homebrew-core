class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/d3/2a/c573678f7150f35305f50727bcfd41edf1415fb1e523860f0f0788d99205/git-plus-0.4.9.tar.gz"
  sha256 "b9a9dbbffc030a044cb7d9ee46b3fe1b683162cee52172c7349eda8216680ec6"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f460db814de1238b256ffe8ff73e20517e818ba431226fad2c93090302d4e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f460db814de1238b256ffe8ff73e20517e818ba431226fad2c93090302d4e7"
    sha256 cellar: :any_skip_relocation, monterey:       "54a3a8bf7d28d2dff77088e68eb79ed26543a7b9f93d9cd580964258d25c297e"
    sha256 cellar: :any_skip_relocation, big_sur:        "54a3a8bf7d28d2dff77088e68eb79ed26543a7b9f93d9cd580964258d25c297e"
    sha256 cellar: :any_skip_relocation, catalina:       "54a3a8bf7d28d2dff77088e68eb79ed26543a7b9f93d9cd580964258d25c297e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8dbc62e560dea03502ccc9f3bdc8f7ba69a6e5abbb62d7128b4ab86c27fb83a"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "testme" do
      system "git", "init"
      system "git", "config", "user.email", "\"test@example.com\""
      system "git", "config", "user.name", "\"Test\""
      touch "README"
      system "git", "add", "README"
      system "git", "commit", "-m", "testing"
      rm "README"
    end

    assert_match "D README", shell_output("#{bin}/git-multi")
  end
end
