class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://files.pythonhosted.org/packages/0f/5b/9a6ff3a69975a226e2f4a0abf34a02cc6f64af95cf8e432518b890722ff4/oci-cli-3.2.0.tar.gz"
  sha256 "00edbbb4dd23b1e39fe8c23980bc23eaae36eb797cf4b0180a3614f1586b456f"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https://github.com/oracle/oci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7b14edf93726d3e53cbaa2735d49a1efce8eda58e8165e45e3daf2c10fb9ab4c"
    sha256 cellar: :any,                 arm64_big_sur:  "faf276e4bc35e5cbe9cb4e1df04542bcc578fa5e0bd3bbba630ef747146f8c52"
    sha256 cellar: :any,                 monterey:       "ea5d2eeadcf56f7fa727a14377d570e44070c1fea231e984334c23621012d131"
    sha256 cellar: :any,                 big_sur:        "631a43006942d21049e013672dbbdb8e0fcd563ecbe14a77d3dfbdcaff9e942a"
    sha256 cellar: :any,                 catalina:       "2bd5f34c8fb2293d1fdf3fe951de1cf928666bbadf1b9ba894b64450ef6daefb"
    sha256 cellar: :any,                 mojave:         "8b09f30bd4019db9d428e97a629cd50594f115a48f702e0e0741f9bac0eb667f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "683c1afbf44d863e131c728663525cd1d26fc9bbc2c08a132c915b17c379280b"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/dc/bd/2565b8533bb8cf66e10a9e68a1d489ad839799b2050f0635039e614e3b1a/arrow-1.2.0.tar.gz"
    sha256 "16fc29bbd9e425e3eb0fef3018297910a0f4568f21116fc31771e2760a50e074"
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
    url "https://files.pythonhosted.org/packages/fe/c8/86d9686a6a4ce133ec814c4e59369663e8292df7df932e6062f1188fb454/circuitbreaker-1.3.1.tar.gz"
    sha256 "1b2d01cd5d02ddb248e1e4d34c1e9d4ee8ebef1d0b8e648b514c936a90df4f7d"
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
    url "https://files.pythonhosted.org/packages/98/27/09f018439d9be92ec90d6d7ee214b4f28a64e90c0618abb311d5153de0b7/oci-2.48.0.tar.gz"
    sha256 "7e4d234aea7bed22082a8f1d9e0513d02845ce97f2d19ff2429045435349bc5b"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
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
