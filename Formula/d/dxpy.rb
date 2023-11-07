class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/b2/9d/7ddd60fa6c9c8237e4392a4ccaa65e6ff8d3ca87b16e0f6633d568c2b5b3/dxpy-0.363.0.tar.gz"
  sha256 "0da6f5c783f5614220d8962969eacc73767a991c0656a238c403a48f2b0dc3f1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20a4422c3279fb81c620e10da1d652d343829e72ef6b394935a598f38aa4f0f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c60bd10efa6981b1e1cf127255e4032a72ccaa7838ecd80a177fd4efc70457fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9e8f6d11746c3bef16ac6a3085c33eaac70a7abcf27d0d7754e165a5f8184d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec0bfe89f104c4ef83e0bb63fd734644335a359b39aa41c277c7159c597f8966"
    sha256 cellar: :any_skip_relocation, ventura:        "748788a87632770c34ae5ae90c250778724941e0f8d672b2ddbd6047ab15ae06"
    sha256 cellar: :any_skip_relocation, monterey:       "906bc30cef1442fcf79c1e204e9ebbfa9bbf6d77d126177647f397eb28c80a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6297a1083cde18f56ce79578d9cd2e424a7992c17093357202af08ff1513847"
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
