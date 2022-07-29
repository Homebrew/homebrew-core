class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/ee/cb/244839cf29199438c86e0f254f0d131e41ec39074efe6b71d556d121f275/git-cola-4.0.1.tar.gz"
  sha256 "5d3abc4cae3eadae6728a69950ae7b467ec2bda4f32c30437bcac34c1a331896"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "764ca702d38688dcabb5c4b9f66a7f22c75a459d3f6b8958dcf9774878f2180d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "764ca702d38688dcabb5c4b9f66a7f22c75a459d3f6b8958dcf9774878f2180d"
    sha256 cellar: :any_skip_relocation, monterey:       "209da4235803549d7c09ed2a0a52cf318691da57646e36c97eec54663f38eab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "209da4235803549d7c09ed2a0a52cf318691da57646e36c97eec54663f38eab5"
    sha256 cellar: :any_skip_relocation, catalina:       "209da4235803549d7c09ed2a0a52cf318691da57646e36c97eec54663f38eab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b7d769c22c41700d9813222188aca1bfe1f0971526590ad98da4c666059e0b4"
  end

  depends_on "pyqt@5"
  depends_on "python@3.10"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "QtPy" do
    url "https://files.pythonhosted.org/packages/4f/8b/2830a11f0773dded3bb9943daeed7c1eefb214f84d72a213a5d4681430b2/QtPy-2.1.0.tar.gz"
    sha256 "ca8cd4217175186344299ee4c0f7e7adcf362c70852ba35b255a534077025c06"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
