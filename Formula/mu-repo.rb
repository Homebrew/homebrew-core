class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/fc/3f/46e5e7a3445a46197335e769bc3bf7933b94f2fe7207cc636c15fb98ba70/mu_repo-1.8.2.tar.gz"
  sha256 "1394e8fa05eb23efb5b1cf54660470aba6f443a35719082595d8a8b9d39b3592"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "973ee265fba3e84c33d91f4fac3c50bbe16fd0509d400a7dff96a076126610f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "973ee265fba3e84c33d91f4fac3c50bbe16fd0509d400a7dff96a076126610f9"
    sha256 cellar: :any_skip_relocation, monterey:       "6bce8c91e5a6555bf90de8b3d9944f9fb4b68a4dd7f309a732aa05369d8283b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bce8c91e5a6555bf90de8b3d9944f9fb4b68a4dd7f309a732aa05369d8283b1"
    sha256 cellar: :any_skip_relocation, catalina:       "6bce8c91e5a6555bf90de8b3d9944f9fb4b68a4dd7f309a732aa05369d8283b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c21cdd623c9daa1193ac0b70ca5fe1287fd7e851639d4bbaf7f15a38b34a8ede"
  end

  depends_on "python@3.10"

  conflicts_with "mu", because: "both install `mu` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/mu group add test --empty")
    assert_match "* test", shell_output("#{bin}/mu group")
  end
end
