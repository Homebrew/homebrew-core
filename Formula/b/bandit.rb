class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/aa/c3/0cb80dfe0f3076e5da7e4c5ad8e57bac6ac357ff4a6406205501cade4965/bandit-1.9.4.tar.gz"
  sha256 "b589e5de2afe70bd4d53fa0c1da6199f4085af666fde00e8a034f152a52cd628"
  license "Apache-2.0"
  revision 1
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b7189ed69829e064ecbdf704cbd6e08b3a293cc4f8b6f7b8a905853acd3e879"
    sha256 cellar: :any,                 arm64_sequoia: "97ce6dfbaa20d117c9b42c4c86f7dbc1ecaeec0d729c95dfd3c62a7233d10f08"
    sha256 cellar: :any,                 arm64_sonoma:  "046c7ea7788b6033fc02fbf9a274ac7e61323195392af3fd88835e1383621fca"
    sha256 cellar: :any,                 sonoma:        "b90fd2ec3020a447430ca6c678a90926c961251bd0af287d2c7c4f8a4289069c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84acad612b361d5211dae97c27d1c1f75251eb1548f636ad9a5e60cad0fd6b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeed013586f401f4d8233ad572169066746a062e655e719c3d459dc981101870"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/a2/6d/90764092216fa560f6587f83bb70113a8ba510ba436c6476a2b47359057c/stevedore-5.7.0.tar.gz"
    sha256 "31dd6fe6b3cbe921e21dcefabc9a5f1cf848cf538a1f27543721b8ca09948aa3"
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
