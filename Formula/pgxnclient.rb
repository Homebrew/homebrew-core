class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://github.com/pgxn/pgxnclient/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0d02a91364346811ce4dbbfc2f543356dac559e4222a3131018c6570d32e592a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bafbe9dbacd8ae05209b56ffee90361ca96cdd840f8071fceeaca5ba44ff6097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0955d94598c00308ea24a6b39ce8aa4b3858ed5e78456516d3cc9672bce65703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dc7ad36b1a2d48f6c358e9d127ebfdcb133e0fc3acded09b8163a312b31f208"
    sha256 cellar: :any_skip_relocation, ventura:        "af2acaa2e5366b42d34f2b60d8227c1ba3c7c320f87022f19c4b58208b9e3c57"
    sha256 cellar: :any_skip_relocation, monterey:       "cea13f9ff74e774c99d00b0edb067e276d6e400fd49adbd942ee9fdef210e4c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e504d4d32279c420015a4bc2bcbd6d9c733a8b3ddfbd627067c8a702a119bca"
    sha256 cellar: :any_skip_relocation, catalina:       "8b57b7c040b9af6b4be7f92b95ec2a207a7f554e416b7adf769f4d0aa6426074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f62cb66dd352d213a814474cd8c02e23d3c41cfe7b7420d064fe6ab2edca075"
  end

  depends_on "python@3.11"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
  end
end
