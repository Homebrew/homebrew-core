class Pocsuite3 < Formula
  include Language::Python::Virtualenv

  desc "Open-sourced remote vulnerability testing framework"
  homepage "https://pocsuite.org/"
  url "https://files.pythonhosted.org/packages/0f/05/b17921332ab312c04ccc67b3d01a0d4318a4d45eb0315531f66d41a89639/pocsuite3-2.0.8.tar.gz"
  sha256 "9508ffec49519e5421f19472a582d747b44bf3db289357ed39227e9addfceec3"
  license "GPL-2.0-only"
  head "https://github.com/knownsec/pocsuite3.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "0097bbfa0460a7eec73479e08c33c94ba268aafb4f0e43c9459098e00f2e95b2"
    sha256 cellar: :any,                 arm64_ventura:  "5e25bb42134c7486f2c934098233519e30350477e3c7cb694f7639def9a514c2"
    sha256 cellar: :any,                 arm64_monterey: "1949f056cc986cdb183e963d16e1e3da9fa66563921eaf5bfe4f5d9ee32504ea"
    sha256 cellar: :any,                 sonoma:         "3c331ff7f40c0f30e6ac6d5289d5b249119bad59947e1dd82f77b9b0ae527ad8"
    sha256 cellar: :any,                 ventura:        "67fc63c747f39b6de26ce91035550b16890facfcf6680cac63e24985d47bc31b"
    sha256 cellar: :any,                 monterey:       "a86db8287d28584b755d16f53bd64c27119c2713bc5d56078cc51b007e71df44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50787f97c315d308e1b3deafeb19d318269aaf689b73fc2428c5844b17be6c88"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/db/38/2992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8/colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "dacite" do
    url "https://files.pythonhosted.org/packages/6f/6d/f7ee0f5410665cdfbd56d0caf5da9217410348e5a0c11d3e6cfe1c1ddd7a/dacite-1.8.0.tar.gz"
    sha256 "6257a5e505b61a8cafee7ef3ad08cf32ee9b885718f42395d017e0a9b4c6af65"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/25/14/7d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bc/docker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/31/4b/22a48749ffaf4d478192769d783233c37f00f0005d349dc6cf4da7003e3a/Faker-24.1.0.tar.gz"
    sha256 "4fb0c16c71ad35d278a5fa7a4106a5c26c2b2b5c5efc47c1d67635db90b6071e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jq" do
    url "https://files.pythonhosted.org/packages/22/50/ab53cc23eddad14a28920e95523b9f39849d9e3139836ec8fcbb7e8e3517/jq-1.6.0.tar.gz"
    sha256 "c7711f0c913a826a00990736efa6ffc285f8ef433414516bb14b7df971d6c1ea"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "mmh3" do
    url "https://files.pythonhosted.org/packages/63/96/aa247e82878b123468f0079ce2ac77e948315bab91ce45d2934a62e0af95/mmh3-4.1.0.tar.gz"
    sha256 "a1cf25348b9acd229dda464a094d6170f47d2850a1fcb762a3b6172d2ce6ca4a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/19/d3/7cb826e085a254888d8afb4ae3f8d43859b13149ac8450b221120d4964c9/prettytable-3.10.0.tar.gz"
    sha256 "9665594d137fb08a1117518c25551e0ede1687197cf353a4fdc78d27e1073568"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/31/a4/b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1/pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/eb/81/022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577d/pyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "scapy" do
    url "https://files.pythonhosted.org/packages/67/a1/2a60d5b6f0fed297dd0c0311c887d5e8a30ba1250506585b897e5a662f4c/scapy-2.5.0.tar.gz"
    sha256 "5b260c2b754fd8d409ba83ee7aee294ecdbb2c235f9f78fe90bc11cb6e5debc2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/10/56/d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764/termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  # Drop setuptools dep: https://github.com/knownsec/pocsuite3/pull/420
  patch do
    url "https://github.com/knownsec/pocsuite3/commit/cddfbdb6b7df51f985abe8db7ecd24d5d3b5a92a.patch?full_index=1"
    sha256 "b1aff714f6002b46c2687354ce51ce0f917d5d13beb20fb175f3927f673f9163"
  end

  # Fix SyntaxWarning's: https://github.com/knownsec/pocsuite3/pull/420
  patch do
    url "https://github.com/knownsec/pocsuite3/commit/2505bc8b1501866b9193398575c5653614e131f4.patch?full_index=1"
    sha256 "656929162b5ddd99ae7d98a4580e9dab8914bf0c66f23ab1d7aacb0c2b13a84c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Module (pocs_ecshop_rce) options:", shell_output("#{bin}/pocsuite -k ecshop --options")
  end
end
