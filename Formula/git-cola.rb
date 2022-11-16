class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/98/5b/b2966e7aa30b120fe20b2179fe1b20e3152a5618d2c6d69a21ca31b1fc49/git-cola-4.0.3.tar.gz"
  sha256 "bb9c7d5e9149eca61ac2b485ea38b881937d6d6eef3425e9c64a2590f8272348"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4929d2b1969df57af88210caf42d049bef7de292fa9b4ace21a9866652312d9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46015060a163bdac9950d072becca764182a5bff75fb36eb8003cf125abd087f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31ee500fccc791c379088cc9e5b2fed23bdc6ee9b815f75ba111fb85fd09fbaf"
    sha256 cellar: :any_skip_relocation, monterey:       "c905d8125931d36f1c1cf15d59f39205b308a900b956d3ab27a1758fbb92223d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d15f7c0da71859a761ef1bbaa7d065b6918ab914459ebe2daadc54e1eac05c0"
    sha256 cellar: :any_skip_relocation, catalina:       "688111f6b531f2324913d8cf2e05b52c3e3e608bc325dedcfa46ed211a1877ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b27f24fc03f51620eb77dccbda25a05604604f8602b6c5cc6db1c505b8c63a"
  end

  depends_on "pyqt@5"
  depends_on "python@3.11"

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
