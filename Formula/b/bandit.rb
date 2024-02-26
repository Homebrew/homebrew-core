class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/50/04/f9efce9197981a6b36e44433c3f7349016f92ab69ddf9f9339d2fce0720d/bandit-1.7.7.tar.gz"
  sha256 "527906bec6088cb499aae31bc962864b4e77569e9d529ee51df3a93b4b8ab28a"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "fed8d9499596684943585a3a800c379e885dd062fd5f510b1dff73358a95c251"
    sha256 cellar: :any,                 arm64_ventura:  "f6544aa2153b37749ad2fa05f92133a26790ea42d08f7686d4be566371caff4b"
    sha256 cellar: :any,                 arm64_monterey: "4f58756624211901ae161360c26a7d8ee8eef8be2fc71a45de7df27a1e2172d2"
    sha256 cellar: :any,                 sonoma:         "82793e9b96d226bad9a551626cbcc347306199cae978002873149ccb00d296f4"
    sha256 cellar: :any,                 ventura:        "aefe099a137f19dc2e47f7036806f175b9ae6ea2d79ffdf0454dab7b1aa83097"
    sha256 cellar: :any,                 monterey:       "ae898f0bbc39782bfc3d30c0fe534c70e3155fa0fbff9dbb098d417d56b29599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b4bff05808ad34f5f41f250aab80cb7d8a74bd2e4d6faa5db91a5a0cb94af5"
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
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
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
