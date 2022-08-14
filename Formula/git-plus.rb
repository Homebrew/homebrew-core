class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/d3/2a/c573678f7150f35305f50727bcfd41edf1415fb1e523860f0f0788d99205/git-plus-0.4.9.tar.gz"
  sha256 "b9a9dbbffc030a044cb7d9ee46b3fe1b683162cee52172c7349eda8216680ec6"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e18827b5f7b9d5257e71f66cbdf128b428cd00fe1b72420c6a2fa07577133eb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e18827b5f7b9d5257e71f66cbdf128b428cd00fe1b72420c6a2fa07577133eb6"
    sha256 cellar: :any_skip_relocation, monterey:       "2b05fd7bb5104131594b5700fa86e34b6211a7aa0e5dadf079373e03adf8ca4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b05fd7bb5104131594b5700fa86e34b6211a7aa0e5dadf079373e03adf8ca4f"
    sha256 cellar: :any_skip_relocation, catalina:       "2b05fd7bb5104131594b5700fa86e34b6211a7aa0e5dadf079373e03adf8ca4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b918418cdbed0eed56bacd3dc962e017a1659a98a573dafd9b636873d9bf577e"
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
