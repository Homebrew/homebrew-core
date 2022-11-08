class Credstash < Formula
  include Language::Python::Virtualenv

  desc "Little utility for managing credentials in the cloud"
  homepage "https://github.com/fugue/credstash"
  url "https://files.pythonhosted.org/packages/b4/89/f929fda5fec87046873be2420a4c0cb40a82ab5e30c6d9cb22ddec41450b/credstash-1.17.1.tar.gz"
  sha256 "6c04e8734ef556ab459018da142dd0b244093ef176b3be5583e582e9a797a120"
  license "Apache-2.0"
  revision 5
  head "https://github.com/fugue/credstash.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "52608d3499897c52d289b7ba30bd5ef1b4ac9d5638aceb0f5d6118cdda25922a"
    sha256 cellar: :any,                 arm64_monterey: "e2cf82ffe8572152a4d29954d245c9c1cca360650d5647524f8e18913c97f0f3"
    sha256 cellar: :any,                 arm64_big_sur:  "b54243ce850fc1eab92dd2c54438477f7e6effff757860f5988bd93a93fb6986"
    sha256 cellar: :any,                 monterey:       "d5222f55dc5c4cf986d2ad2ad7831587bb39a0215c102a9374a422e5e8d55b0f"
    sha256 cellar: :any,                 big_sur:        "9969ff2c103da08a614bde619554268c164c559fc899b6849e92644b92cd0571"
    sha256 cellar: :any,                 catalina:       "9374f353b786d61526a755c995b99ecaba4e61a1456813f9a5a36cb820a10023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "381772e9cc4dd54df348808c8b4c7e1c0e72dcfb6931bd40fc5b857987659994"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/df/e4/893fc4af6ee0c801725b48ba4d3120705126edab71e0fe84f8eb4850c427/boto3-1.26.4.tar.gz"
    sha256 "244fd0776fc1f69c3ed34f359db7a90a6108372486abc999ce8515a79bbfc86e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/32/c1/3a3cbbdc58a71c1dfafbeeb79dd09b68a030ff5c52df7ad8e87d5ed57c10/botocore-1.29.4.tar.gz"
    sha256 "fa86747f5092723c0dc7f201a48cdfac3ad8d03dd6cb7abc189abc708be43269"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/13/dd/a9608b7aebe5d2dc0c98a4b2090a6b815628efa46cc1c046b89d8cd25f4c/cryptography-38.0.3.tar.gz"
    sha256 "bfbe6ee19615b07a98b1d2287d6a6073f734735b49ee45b11324d85efc4d5cbd"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    output = shell_output("#{bin}/credstash put test test 2>&1", 1)
    assert_match "Could not generate key using KMS key", output
  end
end
