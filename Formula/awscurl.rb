class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/6e/95/74209c24ac099c109109229bee14886c210edefb3f6bd73096e3a2277a93/awscurl-0.26.tar.gz"
  sha256 "5cb14aa948160e8fda1e1285ab4824ee0f54b0af87f9bd169ee49fab0c09cb6c"
  license "MIT"
  revision 1
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0684b73a3273fb2bfcaedccaf6a6aaf3d23e907c2a0048174480e520d87a0b75"
    sha256 cellar: :any,                 arm64_monterey: "9a4a0c0bb4979d0ee08b9ffff456d79191326fa0ed7d29dc19e0323ec6713123"
    sha256 cellar: :any,                 arm64_big_sur:  "6675dd94fe8ce001a56f39fd8b973aeae6852e51316adbd625190f4cfb5a70c1"
    sha256 cellar: :any,                 ventura:        "8549b5cd37215e32b78d0163bb832d29267282a230c3d52a2a6eec55a7d56b1e"
    sha256 cellar: :any,                 monterey:       "7eac4d1801aeb8fc8fd0718d7c09b85927e866616d5f136f20e6bae434e7af6b"
    sha256 cellar: :any,                 big_sur:        "471ca74336a65054df2342fbce5b4d88facee4321ee0f531f599cc3df4cdb0d5"
    sha256 cellar: :any,                 catalina:       "fa3fbbbef4bf6663c7426d446caac167683081465f4c554369137af194059768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e344df93eb1aee6eac992fdfed5495d4d07c186dbaaca36bebe3a24fbd1c75e3"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/4b/c0/3a47084aca7a940ed1334f89ed2e67bcb42168c4f40c486e267fe71e7aa0/configparser-5.3.0.tar.gz"
    sha256 "8be267824b541c09b08db124917f48ab525a6c3e837011f3130781a224c57090"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/e3/3f/41186b1f2fd86a542d399175f6b8e43f82cd4dfa51235a0b030a042b811a/cryptography-38.0.4.tar.gz"
    sha256 "175c1a818b87c9ac80bb7377f5520b7f31b3ef2a0004e2420319beadedb67290"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/e7/2f/c6d89edac75482f11e231b644e365d31d5479b7b727734e6a8f3d00decd5/pyOpenSSL-22.1.0.tar.gz"
    sha256 "7a83b7b272dd595222d672f5ce29aa030f1fb837630ef229f62e72e395ce8968"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  resource "urllib3-secure-extra" do
    url "https://files.pythonhosted.org/packages/c9/67/76b7c055ea787729bb9f839a84689ea2f88e217519d59ae547824431ec95/urllib3-secure-extra-0.1.0.tar.gz"
    sha256 "ee9409cbfeb4b8609047be4c32fb4317870c602767e53fd8a41005ebe6a41dff"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "No access key is available",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-none-existant-bucket.s3.amazonaws.com 2>&1", 1)
  end
end
