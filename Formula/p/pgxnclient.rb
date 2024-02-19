class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://github.com/pgxn/pgxnclient/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0d02a91364346811ce4dbbfc2f543356dac559e4222a3131018c6570d32e592a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08ea55af7903922e5c8a9b289a3ba3dabb904a145a108a1f1bffdab9f92a652b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c92674650658323f030a569170532caa447949e943cd47f565eda245367c4372"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "796c5bbb41c766adbc87d5173ceea93899b9bff2fac87e4f26995a40e86503f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d3f26f8b40b00f9962b2fce55deb37b9681a356467df72cd921f3f9848680a1"
    sha256 cellar: :any_skip_relocation, ventura:        "c0c62552df7fa700a66f4295506aaf4076d133228ec2ac0e0965bead4b075636"
    sha256 cellar: :any_skip_relocation, monterey:       "d90e284c762494ddcb9f8a5e48e00a931b847c7551752b0a18b86dba28ac14ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80fa16b7a7fed4293568a6f9818b021e23f80e831adf5f81a080ab5faa00c852"
  end

  depends_on "python@3.12"

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
    assert_match version.to_s, shell_output("#{bin}/pgxnclient --version")
  end
end
