class Pydocstyle < Formula
  include Language::Python::Virtualenv

  desc "Python docstring style checker"
  homepage "https://www.pydocstyle.org/"
  url "https://files.pythonhosted.org/packages/4c/30/4cdea3c8342ad343d41603afc1372167c224a04dc5dc0bf4193ccb39b370/pydocstyle-6.1.1.tar.gz"
  sha256 "1d41b7c459ba0ee6c345f2eb9ae827cab14a7533a88c5c6f7e94923f72df92dc"
  license "MIT"
  head "https://github.com/PyCQA/pydocstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8de054460c03ef2ae090e16de96d5555673f615a0cc66926c23b71cd67b1f2c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "271f7fbfd202df294424111730f3fa7b29b9e07602a13b06239f4c9216635a45"
    sha256 cellar: :any_skip_relocation, catalina:      "3658ffaa56d1bc1b0da49974e889e3b37e09a069fca1a3facc789d5293fb457d"
    sha256 cellar: :any_skip_relocation, mojave:        "66244942f557879c00ed156a7f9bd70a70230ece72b6e22d5f0ef9800e4a07e5"
  end

  depends_on "python@3.9"

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/a3/3d/d305c9112f35df6efb51e5acd0db7009b74d86f35580e033451b5994a0a9/snowballstemmer-2.1.0.tar.gz"
    sha256 "e997baa4f2e9139951b6f4c631bad912dfd3c792467e2f03d7239464af90e914"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring():
        """  extra spaces  """
        pass
    EOS
    output = pipe_output("#{bin}/pydocstyle broken.py 2>&1")
    assert_match "No whitespaces allowed surrounding docstring text", output
  end
end
