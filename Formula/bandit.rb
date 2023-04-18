class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/5e/67/997278e785edf155bd57163ae7030f979a0907857365cb30815d93b5354b/bandit-1.7.5.tar.gz"
  sha256 "bdfc739baa03b880c2d15d0431b31c658ffc348e907fe197e54e0389dd59e11e"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa3afa173d1e7572ec381a7aeb8bec78d6e15a5959084d4be477964268689db6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d822580c5d91458b769fc4ab27036ad5650e726ef41ea4d1dd6e5026fb3d3e0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d61224cd2d8814ad36fe96b826f589e6a7de26fe4d4368963308aa5ab842d29e"
    sha256 cellar: :any_skip_relocation, ventura:        "ab90908f077546066adc0be87503d93ea4974fbd40229d95f0f3d8c443e51240"
    sha256 cellar: :any_skip_relocation, monterey:       "6a229a36dfec67064f83244f4adfbdf78af5a5145a7159249a6f7289cf704c97"
    sha256 cellar: :any_skip_relocation, big_sur:        "a33c88dfcf620565d537c03e5cf6312589f2e71bc9299a17aec0ceb30bde53ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f773304d077124de18019c2d141e85b5ef8360afc4775a347064a8c3d904fea"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/5f/11/2b0f60686dbda49028cec8c66bd18a5e82c96d92eef4bc34961e35bb3762/GitPython-3.1.31.tar.gz"
    sha256 "8ce3bcf69adfdf7c7d503e78fd3b1c492af782d58893b650adb2ac8912ddd573"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
    sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/5e/0e/ef0a49be56dbc4052a086888cd2490e15fcc95b0eda79e9d0e737b1ab93d/rich-13.3.2.tar.gz"
    sha256 "91954fe80cfb7985727a467ca98a7618e5dd15178cc2da10f553b36a93859001"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/f1/25/993d09dc7be3e7927228853c75324104d734bb784bd766b025ebf9f47b16/stevedore-5.0.0.tar.gz"
    sha256 "2c428d2338976279e8eb2196f7a94910960d9f7ba2f41f3988511e95ca447021"
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
