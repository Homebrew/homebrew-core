class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://files.pythonhosted.org/packages/4d/b6/d62fc7c22f8a5ed83a16ad35c9e899f7b38d36f92542a11e454229ba3114/oci-cli-3.10.2.tar.gz"
  sha256 "81be2c4a8d46ed25deed0559231f33310a276f5eb957d755a6bff306b0e2b2f0"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https://github.com/oracle/oci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ab7d720efa576398802b625cbe50282eaf5b7a7477d6c5a2c4c45fffff1a6831"
    sha256 cellar: :any,                 arm64_big_sur:  "a0b130a605f361905240a1cb8f77630871b76f3860776efca194d1a200876854"
    sha256 cellar: :any,                 monterey:       "cca9f1e81addb960365438880dc5751f6ee44d43fb4309456cbdca9cdf44641e"
    sha256 cellar: :any,                 big_sur:        "437b8b9a57d83bef377e7de31c67a4fcf380038e61a50371fe3f792608bb1f70"
    sha256 cellar: :any,                 catalina:       "86d91ee85da43c38d59030d958bd2ad0017e92232ae2f63f2549fa4cd51ee794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29bddd21d85e9361ed86bd7e291c9d455e7c33a0fbf3af1e30fa295a7e626a4a"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/48/28/30a5748af715b0ab9c2b81cf08bd9e261e47a6261e247553afb7f6421b24/arrow-1.2.2.tar.gz"
    sha256 "05caf1fd3d9a11a1135b2b6f09887421153b94558e5ef4d090b567b47173ac2b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
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
    url "https://files.pythonhosted.org/packages/80/b3/b2dff659cdad6f1606b3b5e75bbbb1f6f5f56a4061b21afee2100a80ad25/oci-2.70.1.tar.gz"
    sha256 "9c792ae3cadf3863981dd70fa785c763fddcd1a9256b53d375fe769030852549"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
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
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
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
