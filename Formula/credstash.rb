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
    sha256 cellar: :any,                 arm64_monterey: "91c5491f7b0e7f58e7b4cc367089d2044e404c848b5d4e34d149c38986f4b43a"
    sha256 cellar: :any,                 arm64_big_sur:  "1a21ca32f0125ee957a6d5982476b5dd1cffc5171cf6fad7ae8fb3c30435adec"
    sha256 cellar: :any,                 monterey:       "d929615e2f24a34beaa4a2b1d4aa3e43418264a6979d4ef0841e278fca3fd76e"
    sha256 cellar: :any,                 big_sur:        "a1feb9d1ea89d16a1f081073c9489ba1fa10b01efc4a14a6fcd63aaf99f22a21"
    sha256 cellar: :any,                 catalina:       "d024fa038ba23386b70bc44c6a832e4d5069168672f7501dc4868d1d6d1edd0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c95299a9322b47842ca1dd80609864e3aa62bc0d8d0373bcc4a92e4844997a4"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/63/81/22ecf9fd7a283ee3936c23552f370dfd261302d55b24dceabc25f9ab4254/boto3-1.20.26.tar.gz"
    sha256 "9c13f5c8fadf29088fac5feab849399169b6e8438c3b9a2310abdb7e5013ab65"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d0/c0/0f8026e7d0bbb633ab048cdd121aa4446e30c39aada083af4d724be0822a/botocore-1.23.26.tar.gz"
    sha256 "0a933e3af6ecf79666beb2dfcb52a60f8ad1fee7df507f2a9202fe26fe569483"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
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
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
