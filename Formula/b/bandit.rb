class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/1a/a5/144a45f8e67df9d66c3bc3f7e69a39537db8bff1189ab7cff4e9459215da/bandit-1.8.3.tar.gz"
  sha256 "f5847beb654d309422985c36644649924e0ea4425c76dec2e89110b87506193a"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5edf7453bbba24200a63d47d696de34b29593cb3caa4605857b3784eba3341b0"
    sha256 cellar: :any,                 arm64_sonoma:  "b700080db1ad11542ba34e8cc6740a49dda5a262bb1570569a4adc68d5694689"
    sha256 cellar: :any,                 arm64_ventura: "f0df06af03e5c5d4fa664e5cc0be6e20078a6269e1d23f3db7240e41d31201dc"
    sha256 cellar: :any,                 sonoma:        "092350c2312631dee3f6dff891eca1a3656012118b5bf30e2d524858fb1072e9"
    sha256 cellar: :any,                 ventura:       "f889a061f551474f3b718557a08b95996eff92ab2da98109d18898dde8bbb1cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec0fee9adf94beb73649de9d903434a59cc2ced0463594f3f59c81aaa60d1e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b6f1eab386584966d9494c3a59d96327e3462889597af88b826a3be2dadbf0"
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
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/4a/e9/4eedccff8332cc40cc60ddd3b28d4c3e255ee7e9c65679fa4533ab98f598/stevedore-5.4.0.tar.gz"
    sha256 "79e92235ecb828fe952b6b8b0c6c87863248631922c8e8e0fa5b17b232c4514d"
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
