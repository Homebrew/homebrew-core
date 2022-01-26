class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://files.pythonhosted.org/packages/a0/6f/ea6c03437dd55adb9c175913676e62ccaa1fed0c72a403ba60c78c8b64db/oci-cli-3.4.4.tar.gz"
  sha256 "046557d58d6070f7eb62175c40cedfce6beee7355257f9b803177ff760f80757"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https://github.com/oracle/oci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c36cf7276e4a353c9ccd55e6368cd5e1cf260d6c52794f63235a486c2a01ab6f"
    sha256 cellar: :any,                 arm64_big_sur:  "569dbaf6678a4a5f7576baa5f4cbcd5b0518848ac1b4afbe4cd2f5d3a01b27f3"
    sha256 cellar: :any,                 monterey:       "7720ba519a3f2067aafc55e11ee6dbff12597dc1ac456752cdbb413b21e3af4f"
    sha256 cellar: :any,                 big_sur:        "2bd7e4a200bbf664dcb401a9324fc9f8e96e3b21f4e472f0b3b140cc2ec29f8b"
    sha256 cellar: :any,                 catalina:       "22051ae67c0be07f914985c891bde145435c6bf5687c128b21ac004b573473af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "913b9b7292e0796ee95ccfcd40b6c047cb609a9f7516f6feef1e131358ad0e7e"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/25/e2/85d4a709a3ea58f8e36b4db9eb7927560a2fa4b6f8f362fb6475962fec51/arrow-1.2.1.tar.gz"
    sha256 "c2dde3c382d9f7e6922ce636bf0b318a7a853df40ecb383b29192e6c5cc82840"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/27/3f/2e8de6f352fddfd07eca3072b4757f68f5dd2032d4b2ad8e115c6b1bf5bc/circuitbreaker-1.3.2.tar.gz"
    sha256 "747d4ced5c0797e2ab1d3e00a03b312db23e7ec65106148fc63beec25bbba50f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/6b/f5/4cb0d80c12b74901a3f4e9de25592ff9d986eb6adcfbefee6f0d4bb4f336/oci-2.55.0.tar.gz"
    sha256 "45b84677c6ae2e3c9a1474d18abbdf6bae4d04ae050fb03009b869823d5f71cd"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0d/1d/6cc4bd4e79f78be6640fab268555a11af48474fac9df187c3361a1d1d2f0/pyOpenSSL-19.1.0.tar.gz"
    sha256 "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    version_out = shell_output("#{bin}/oci --version")
    assert_match version.to_s, version_out

    assert_match "Usage: oci [OPTIONS] COMMAND [ARGS]", shell_output("#{bin}/oci --help")
    assert_match "", shell_output("#{bin}/oci session validate", 1)
  end
end
