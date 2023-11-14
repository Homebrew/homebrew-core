class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/f2/98/473acbfece859ba22467ec5e5ebb4f07f5b7c230b18dd1151cb0f402b824/dxpy-0.364.0.tar.gz"
  sha256 "1c3c18281261e4e3ce8566f44d61f017c3e9231a848940ba99ff2827a4f0fc06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c657c3c579834351f72e99e9221e72ecc121e9b5aa9a9c10c841e4495dbbd191"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0494bf1eeb2eb9611f06691621380872825ccbd78e03c22a150509ee3bd43cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b429713110e03184f3d52e5cc678e39e68c36a5b945ec69f55b7495e8562d1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b516393faab1c3cf243dec44317ff363546949e8e617ee070c92fb76db2ef51c"
    sha256 cellar: :any_skip_relocation, ventura:        "b50e49806e4aeb46117dd8831d57c1c36287f741c06e9d114278dfafadc9242f"
    sha256 cellar: :any_skip_relocation, monterey:       "f0b68419d4879cbd9e672ac5f02fff0e171dbd8b0e1c74e40415c7f705b84067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b4a06b005c63c9c7525ad712d49887ed2fa6543709781d85d4129fbfe085c1"
  end

  depends_on "cffi"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-psutil"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/35/d4/14e446a82bc9172d088ebd81c0b02c5ca8481bfeecb13c9ef07998f9249b/websocket_client-0.54.0.tar.gz"
    sha256 "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
