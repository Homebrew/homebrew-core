class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/fc/3f/46e5e7a3445a46197335e769bc3bf7933b94f2fe7207cc636c15fb98ba70/mu_repo-1.8.2.tar.gz"
  sha256 "1394e8fa05eb23efb5b1cf54660470aba6f443a35719082595d8a8b9d39b3592"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bfa8b88548cb8bde371ba82d961023fb6380097fc0f9725738a3e8ef9e2c5ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bfa8b88548cb8bde371ba82d961023fb6380097fc0f9725738a3e8ef9e2c5ca"
    sha256 cellar: :any_skip_relocation, monterey:       "f22765952278d1299a518c8c9835a613045c46e5da7a68f746764402b265f590"
    sha256 cellar: :any_skip_relocation, big_sur:        "f22765952278d1299a518c8c9835a613045c46e5da7a68f746764402b265f590"
    sha256 cellar: :any_skip_relocation, catalina:       "f22765952278d1299a518c8c9835a613045c46e5da7a68f746764402b265f590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "753d0bded50ce2ea748a30779ff838e56dd6436a85d3f608386f3517c04568b4"
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
