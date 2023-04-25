class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/fb/ee/074d2116f87048955dbba663d769f9a16108c3c88a9cd667e87c3c4bb4ad/cruft-2.14.0.tar.gz"
  sha256 "ba3d976de1cad437b6a92239b6ec844ea8547e09de796ef505d320c356c45de5"
  license "MIT"
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca7d067e72751aceea7a1b8dce296b1ef7442cb4553a296be2aa1ca158062b2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "727447e41584f2e3cdad9d531b984883d6814cbc2fbcf8cb0019e62d0909b00d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c3edeb267a3b006d0db78eb97014b54e90ad549cc9eb94dbaa078e321ba1e1e"
    sha256 cellar: :any_skip_relocation, ventura:        "dbc17099117f53f534e83b760d7ed045912d978bdb14655c762b1c2f636458a6"
    sha256 cellar: :any_skip_relocation, monterey:       "1f87e745ec6afd3f6294185fe09bad4cc9aa20ad3584d506c50e6f377efbe71f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f252e9404ab059094677925f0c086c718569498273e2854bac1e4db8b5f0af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39306391e3b45af5f8fddc62690609644bbe21b164c375c932edfbf03fac168a"
  end

  depends_on "cookiecutter"
  depends_on "python@3.11"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/5f/11/2b0f60686dbda49028cec8c66bd18a5e82c96d92eef4bc34961e35bb3762/GitPython-3.1.31.tar.gz"
    sha256 "8ce3bcf69adfdf7c7d503e78fd3b1c492af782d58893b650adb2ac8912ddd573"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e1/45/bcbc581f87c8d8f2a56b513eb994d07ea4546322818d95dc6a3caf2c928b/typer-0.7.0.tar.gz"
    sha256 "ff797846578a9f2a201b53442aedeb543319466870fbe1c701eab66dd7681165"
  end

  def install
    virtualenv_install_with_resources

    # we depend on cookiecutter, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    cookiecutter = Formula["cookiecutter"].opt_libexec
    (libexec/site_packages/"homebrew-cookiecutter.pth").write cookiecutter/site_packages
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end
