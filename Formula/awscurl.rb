class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/80/f4/95935ad7041ba008221ce81b698963c8be0c5c97e6fcfd86e0e2009ebacd/awscurl-0.29.tar.gz"
  sha256 "5e1ecd0ab7b014de697a1e161fa483c2263d16c3e156a81bdc8b9a9c2d0ba3f3"
  license "MIT"
  revision 1
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c1f57460088a2b68ab130148253816352249ce5a95cf582a17dbc95aec58e0be"
    sha256 cellar: :any,                 arm64_monterey: "ae3c3e1853c8614945d5524279595c4a1e115b595aa659cd800c14bf709dc8fe"
    sha256 cellar: :any,                 arm64_big_sur:  "ff925bc5dee6ce74b364124dc41d8acbc8c74cfc18da02f6b14e02d10120b0e2"
    sha256 cellar: :any,                 ventura:        "c2210b2a6dee7bd1e7dc02a47578774ad5ef69f0f00b337c410db5360ab06b10"
    sha256 cellar: :any,                 monterey:       "42b9447e0348f6e220e27906e272d9cd5b5f65700d77419c6e7b87d86a20f44c"
    sha256 cellar: :any,                 big_sur:        "ac01fc5702ec2231de6f86f1eb382d521bcd19e0754d2f7baa0d30944cd2abbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f102b41fbe5dc337f5c6b1788ca347e58bcd76379ee222c1c2cc818623e156"
  end

  # `pkg-config`, `rust` and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "libffi"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/4b/c0/3a47084aca7a940ed1334f89ed2e67bcb42168c4f40c486e267fe71e7aa0/configparser-5.3.0.tar.gz"
    sha256 "8be267824b541c09b08db124917f48ab525a6c3e837011f3130781a224c57090"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  resource "urllib3-secure-extra" do
    url "https://files.pythonhosted.org/packages/c9/67/76b7c055ea787729bb9f839a84689ea2f88e217519d59ae547824431ec95/urllib3-secure-extra-0.1.0.tar.gz"
    sha256 "ee9409cbfeb4b8609047be4c32fb4317870c602767e53fd8a41005ebe6a41dff"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "No access key is available",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-none-existant-bucket.s3.amazonaws.com 2>&1", 1)
  end
end
