class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/1a/a5/144a45f8e67df9d66c3bc3f7e69a39537db8bff1189ab7cff4e9459215da/bandit-1.8.3.tar.gz"
  sha256 "f5847beb654d309422985c36644649924e0ea4425c76dec2e89110b87506193a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "964e40d6436049ce517cebd56a98939ea0eeb4405858f971c5a92e6c7d35771c"
    sha256 cellar: :any,                 arm64_sonoma:  "86b80a53756ed989f5387e99ffc2cdf66471de8ebb1e13613cb6d8687803c0b1"
    sha256 cellar: :any,                 arm64_ventura: "2b0d40a68e816b4c22a454e1ad537d2159dd324db64f6c252a1aade66b23a576"
    sha256 cellar: :any,                 sonoma:        "2e8d5dc4e55e16ca0182caf25594fad20de87751965c2209cc35d7f8cd8aad7d"
    sha256 cellar: :any,                 ventura:       "eba00adfe42e1862711d1e0da30a88a081dcf9d73b463ca44fa2090e22c33db1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "756d1d881affc851dec0c7c3f8670cbd1444f47054aa23e343102e5f2341a8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda916adc0015f3f5169e61bbd390979dc962f59a346624d0cad5fa824f37034"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/01/d2/510cc0d218e753ba62a1bc1434651db3cd797a9716a0a66cc714cb4f0935/pbr-6.1.1.tar.gz"
    sha256 "93ea72ce6989eb2eed99d0f75721474f69ad88128afdef5ac377eb797c4bf76b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/28/3f/13cacea96900bbd31bb05c6b74135f85d15564fc583802be56976c940470/stevedore-5.4.1.tar.gz"
    sha256 "3135b5ae50fe12816ef291baff420acb727fcd356106e3e9cbfa9e5985cd6f4b"
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
