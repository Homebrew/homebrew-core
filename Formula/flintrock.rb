class Flintrock < Formula
  include Language::Python::Virtualenv

  desc "Tool for launching Apache Spark clusters"
  homepage "https://github.com/nchammas/flintrock"
  url "https://files.pythonhosted.org/packages/dc/ad/6e3871a510f0d053aa49caee2140a2f64f2d3fa584d3b70408043295fa57/Flintrock-2.0.0.tar.gz"
  sha256 "ccbbc912823772ea733802ca3f9751c98dacda8c67518683a3dc4ec8b1de38dd"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "703a2f46d9c2c2905134bf1d5f4b3b73d3f0fb4a839337c9839c0a7b0ded0f76"
    sha256 cellar: :any,                 arm64_big_sur:  "428e163a901608f2b8cc61b72cbd87819eefe4b6a5564fbb4e699d722da30246"
    sha256 cellar: :any,                 monterey:       "dddda17d2e6ca4c1e4e2a18b9c5ec1b2075eb469ca732b437a71798f9db557d1"
    sha256 cellar: :any,                 big_sur:        "de38bad831b02619d3899a82d61c07275f1fb5401771d276b9a8ab51b4bb3f85"
    sha256 cellar: :any,                 catalina:       "ff0526fd317c499f9b1b338418be4b32a2160eab20d3c06a4bc3a68fe7e4bd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2620d137febb3a5596fee637af9e9f6518f0b982f09ba3311543d014e84045e"
  end

  depends_on "rust" => :build
  depends_on "python@3.9"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
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
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
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
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
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
    url "https://files.pythonhosted.org/packages/94/40/c396b5b212533716949a4d295f91a4c100d51ba95ea9e2d96b6b0517e5a5/urllib3-1.26.5.tar.gz"
    sha256 "a7acd0977125325f516bda9735fa7142b909a8d01e8b2e4c8108d0984e6e0098"
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
