class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/8b/a4/2ce44126137c5a29a9292faa01adb70fea26f882d3aeabd4b812cc633390/git-cola-4.0.2.tar.gz"
  sha256 "b5692841002895bfb2a42be5c8352dbeb454b26f267f56e15d9888e57de0a1b4"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96aff59a2be5b2410c74070480aff491b426394fd6c9824d9a9a4ce82a5e1dc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a2c5f7de6cb2fdc2a5ae475a11be5ec3c7346dcbf81728f6f65af06585374e3"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf0d4a0d3d9574c01f6122be62fd4445986ea54b56b9e81840e18ce24ded080"
    sha256 cellar: :any_skip_relocation, big_sur:        "f169de2b5a0565d2f8cc6fc43a1d27a56a438f22fe7d6fd407ea7eee30731863"
    sha256 cellar: :any_skip_relocation, catalina:       "4ae6746f5f5fa7bc73263b655ced37522faaab69f730d716ad68746e3cba4544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a977d6ca1256c146bff89eb95c8469847c7bef7134c464268a9613dbe778f416"
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
    url "https://files.pythonhosted.org/packages/49/a0/4510b8f848eb2e3d8ed58bca8f876525db43e90812108fccddd16f8cc251/QtPy-2.2.0.tar.gz"
    sha256 "d85f1b121f24a41ad26c55c446e66abdb7c528839f8c4f11f156ec4541903914"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
