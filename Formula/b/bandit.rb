class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/5e/67/997278e785edf155bd57163ae7030f979a0907857365cb30815d93b5354b/bandit-1.7.5.tar.gz"
  sha256 "bdfc739baa03b880c2d15d0431b31c658ffc348e907fe197e54e0389dd59e11e"
  license "Apache-2.0"
  revision 2
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0774c8ed60c9b96fd07838fc3635693d2ea594f5a2f62973617fa3dc4ced96f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "322507c5d7ceef28616ed67dce4e0b8d1d3e974ed27c033f12fda75fd80cc8d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61681a64327360ae6aa629ddfcf57e76ef355f7d1410edd2b7af2c85bbe5e423"
    sha256 cellar: :any_skip_relocation, ventura:        "aaa4e9845934d3d793c3e0d69f4134d90a49e5f7da0469938aefb45b3edeefcf"
    sha256 cellar: :any_skip_relocation, monterey:       "5bb6b70e2d400ed5817275b0ebec22c66ab164a2d5f5773b0ab7d23c861f88d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8367a26e603711d61f2562a1f687fba2368fd3955f621fe1ce69e3e21f6b8244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d0c5a0ebe6e969d57150dd7a55fc11b3aaa93bbb69af2ab21cb05be52916d28"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/8d/1e/33389155dfe8cebbaa0c5b5ed0d3bd82c5e70064be00b2b3ee938da8b5d2/GitPython-3.1.33.tar.gz"
    sha256 "13aaa3dff88a23afec2d00eb3da3f2e040e2282e41de484c5791669b31146084"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ad/1a/94fe086875350afbd61795c3805e38ef085af466a695db605bcdd34b4c9c/rich-13.5.2.tar.gz"
    sha256 "fb9d6c0a0f643c99eed3875b5377a184132ba9be4d61516a55273d3554d75a39"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
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
