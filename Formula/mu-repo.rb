class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/fc/3f/46e5e7a3445a46197335e769bc3bf7933b94f2fe7207cc636c15fb98ba70/mu_repo-1.8.2.tar.gz"
  sha256 "1394e8fa05eb23efb5b1cf54660470aba6f443a35719082595d8a8b9d39b3592"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6812873e9642055410a5a4f71928affeb2720b147c4567e8436529c1e2867ec1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6812873e9642055410a5a4f71928affeb2720b147c4567e8436529c1e2867ec1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6812873e9642055410a5a4f71928affeb2720b147c4567e8436529c1e2867ec1"
    sha256 cellar: :any_skip_relocation, ventura:        "69148e98fc1134364d9bf43e8264fd71ce2869af08ff3ac5f2f41eb802e2b062"
    sha256 cellar: :any_skip_relocation, monterey:       "69148e98fc1134364d9bf43e8264fd71ce2869af08ff3ac5f2f41eb802e2b062"
    sha256 cellar: :any_skip_relocation, big_sur:        "69148e98fc1134364d9bf43e8264fd71ce2869af08ff3ac5f2f41eb802e2b062"
    sha256 cellar: :any_skip_relocation, catalina:       "69148e98fc1134364d9bf43e8264fd71ce2869af08ff3ac5f2f41eb802e2b062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40bdf36a9090b54702f4f5857c8df633ea07049acb8447439de047cbda68a753"
  end

  depends_on "python@3.11"

  conflicts_with "mu", because: "both install `mu` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/mu group add test --empty")
    assert_match "* test", shell_output("#{bin}/mu group")
  end
end
