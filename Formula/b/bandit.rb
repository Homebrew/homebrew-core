class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/50/04/f9efce9197981a6b36e44433c3f7349016f92ab69ddf9f9339d2fce0720d/bandit-1.7.7.tar.gz"
  sha256 "527906bec6088cb499aae31bc962864b4e77569e9d529ee51df3a93b4b8ab28a"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68886ace37600dc4e29cfc0cf8df3f5b9adcd88d31b9743a2f4371e7d208daff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58adb640effcfff23693b3fbed1c787132e2f3f6393c3fe23b01e494b73b7fc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cdb47fb96134839304eb5a8fea400ee49a12c2eb59ad3e89220be3bd1ff5cf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d25433ae2f99a64f1ccbc1faee305b748fa13316d863601ad53e517caff6348"
    sha256 cellar: :any_skip_relocation, ventura:        "29ed0f0774bb0940dcf4778858511fe5cc41711603803834b3bf5c52f8c2c89f"
    sha256 cellar: :any_skip_relocation, monterey:       "4c9adc844d2e52e0e7b6f8d27b300fd243d945974f0b995add8bf8392022cfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23e0dbc801ed827590e967201582db1c00d18f2b5492d70493443a03c7cad47a"
  end

  depends_on "pygments"
  depends_on "python@3.12"
  depends_on "pyyaml"

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
