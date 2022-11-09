class Flintrock < Formula
  include Language::Python::Virtualenv

  desc "Tool for launching Apache Spark clusters"
  homepage "https://github.com/nchammas/flintrock"
  url "https://files.pythonhosted.org/packages/dc/ad/6e3871a510f0d053aa49caee2140a2f64f2d3fa584d3b70408043295fa57/Flintrock-2.0.0.tar.gz"
  sha256 "ccbbc912823772ea733802ca3f9751c98dacda8c67518683a3dc4ec8b1de38dd"
  license "Apache-2.0"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "2e1f6e23d9febd433782653f5bfdabc7de8082f03a33bb2d896964502ff75935"
    sha256 cellar: :any,                 arm64_monterey: "dfdbf5d1cb34ac0b4222a90abafe78162d59bb1d37cf86c04937020becdad602"
    sha256 cellar: :any,                 arm64_big_sur:  "2e998e143c9f2a976462e6081f39656c4693572e02dfb262e369f4e54b6265af"
    sha256 cellar: :any,                 monterey:       "924c7326a1d8b691aa9d85c5bfe24731f4146223f013bff1c9bb206cd7aad54b"
    sha256 cellar: :any,                 big_sur:        "1277d8befcf4750fd278e6ef7e81060d36ea5e060703ac13eabf5ff46ad17fc7"
    sha256 cellar: :any,                 catalina:       "f0d15228ef6ed04419b555f85929d96538c758ae59c8e0363936c2d11eea8393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f9e789e8c5b6124cf603d2424c2ee7e8bcb85d1d1bafb67e8d5aa22738a4368"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d3/61/3b325524005f8d89e5ab62ac71d697ae26f8a546402917b4f759ee707b00/boto3-1.17.90.tar.gz"
    sha256 "bbf727d770a9844834bfbf3f811db1d3438320897f67cfb21cdca5bb8fc23c13"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d4/a4/ef715db7192535688fae0130714fde5dce91ce2ed8e521aad55a213a5820/botocore-1.20.90.tar.gz"
    sha256 "b301810c4bd6cab1b6eaf6bfd9f25abb27959b586c2e1689bbce035b3fb8ae66"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/13/dd/a9608b7aebe5d2dc0c98a4b2090a6b815628efa46cc1c046b89d8cd25f4c/cryptography-38.0.3.tar.gz"
    sha256 "bfbe6ee19615b07a98b1d2287d6a6073f734735b49ee45b11324d85efc4d5cbd"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"flintrock"
    msg = shell_output("#{bin}/flintrock destroy fascism 2>&1", 1)
    assert_match "could not find your AWS credentials", msg
  end
end
