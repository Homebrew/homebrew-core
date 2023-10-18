class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/90/4a/8546678963831a30b5b7ca34210da4873aeef15aff0ab9d598c11fcdf965/dxpy-0.361.0.tar.gz"
  sha256 "455c2a63764e7a1158cdb48abcf987e80d186fb92c23c539d8e6f2e4cc0368c7"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0011354496aaca3de6acd37357ded3c4f0a874295201e4f5cdc4cf3bdf23347"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39849d149af55661a4ba9d74014df5deac3b23d826dfb15f01f181681028851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "099b0ca065fcde9550b128f1273b04d418bc8217ead5ad2c4dae1c7d20a843cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed02d43fa263af6f569226506c7560cc5ea6867677de952eb6a3b9f1497ebe17"
    sha256 cellar: :any_skip_relocation, ventura:        "214b022749c8380df32ec42f0997be7826d9fc0af836307a31635623ae93f105"
    sha256 cellar: :any_skip_relocation, monterey:       "5f4b90f2500f72e0b9e394efb734476503386e2e36c9e1302a6c8f4d7694e5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "312b74775736a9a783a1312f216c78b572fa591805b0146636053f4272980a35"
  end

  depends_on "cffi"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2d/01/beb7331fc6c8d1c49dd051e3611379bfe379e915c808e1301506027fce9d/psutil-5.9.6.tar.gz"
    sha256 "e4b92ddcd7dd4cdd3f900180ea1e104932c7bce234fb88976e2a3b296441225a"
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
