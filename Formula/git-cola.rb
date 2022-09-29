class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/8b/a4/2ce44126137c5a29a9292faa01adb70fea26f882d3aeabd4b812cc633390/git-cola-4.0.2.tar.gz"
  sha256 "b5692841002895bfb2a42be5c8352dbeb454b26f267f56e15d9888e57de0a1b4"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e33d488b67d0ef0ff4ae04eceed4ecc36c4920ce0bf4cb247007cbf85f38141c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdb3e1f6a8185b61c96cec3fdde9c0fc27872bcf4851822581c288b917115b14"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb21993e047ff7642d6de88b633e04d87970a3c71d028b212646c12d59bb12c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d3169cc3fb80f5a8f9b4d52e93707d4a12651e0ffeda9667802a530835a847a"
    sha256 cellar: :any_skip_relocation, catalina:       "f201372554e6f95a625b7e95ce3843f38e96cf8f6c659c1c4d5b367294e76389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b12889d4420549e3349f851d8c1d619bdb603b8fbf3b947e55bae3511cf09e23"
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
