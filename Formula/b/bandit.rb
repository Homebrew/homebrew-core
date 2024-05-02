class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/92/60/3f6e0e58f3f53bbb7227daf61654c9b22ff651e670e44cdc08a0f1d0f493/bandit-1.7.8.tar.gz"
  sha256 "36de50f720856ab24a24dbaa5fee2c66050ed97c1477e0a1159deab1775eab6b"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b472fbd7d48c3d3ae0dd0f3b9b23fb7d07de2b30297ad4320624f5e3df7e0427"
    sha256 cellar: :any,                 arm64_ventura:  "7f682f60ca68357830249bbd07f357854f5cc6a9fa461b7022f1e1cec6669eae"
    sha256 cellar: :any,                 arm64_monterey: "4d1274c2aec2fbab227265785f211ca04d61845432162c70ba006d9fce5a8f20"
    sha256 cellar: :any,                 sonoma:         "f2cd3b9824227efb88cc59dbf43563aa21e51e9d3899bf7c283dd3ba3832c40e"
    sha256 cellar: :any,                 ventura:        "bbb707daca599a120beb13995af487c35d58f3e5de2f60798c676bd8bbd340fc"
    sha256 cellar: :any,                 monterey:       "6b3fb6ed08d0d8bcb27271306b19ece91344bc9614e5f8d45735fb7177f7c958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d2cab7b38f5434f6c67f32c8ff340d73d79fa863dac9a22d49fd7815eae411"
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
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
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
