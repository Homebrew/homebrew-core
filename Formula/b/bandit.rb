class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/1c/a4/ee391b0f046a6d8919eef246aed7c39849e299cc2e50d918b54add397de6/bandit-1.7.9.tar.gz"
  sha256 "7c395a436743018f7be0a4cbb0a4ea9b902b6d87264ddecf8cfdc73b4f78ff61"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5bac823abeade528249e3b9d45dbc2ab0a84e488f78be1040ab21617fec0439"
    sha256 cellar: :any,                 arm64_ventura:  "a1b4f705ed10133cbacc27df4d2123d649088583b1388a6230e79bacf275b03f"
    sha256 cellar: :any,                 arm64_monterey: "e7ba37dbb0601b8dc0469fec742def0d455fca72219f2d8170fd43144d9bbde2"
    sha256 cellar: :any,                 sonoma:         "223eb305b58902776d820a3fd68dbfaa5b5a0bbbf7abf5958629136c9999c30d"
    sha256 cellar: :any,                 ventura:        "ead98dee1441a64356d6d176e5e013701657b9da7b9902947819cf455c272b41"
    sha256 cellar: :any,                 monterey:       "297e6ecc0f731741bc3a17c70dc0de2354b7d566ed266c7d9db512ba3fcf8411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ead754492abb29f84bd36f7bfa3bf5c8edec1154fc20fb01873df104d7ad9cf"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/e7/c1/b210bf1071c96ecfcd24c2eeb4c828a2a24bf74b38af13896d02203b1eec/stevedore-5.2.0.tar.gz"
    sha256 "46b93ca40e1114cea93d738a6c1e365396981bb6bb78c27045b7587c9473544d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}/bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end
