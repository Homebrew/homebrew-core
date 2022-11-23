class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/c3/ea/d7af1ac217f08dc1674d9c870e8749b98d1db9e53217fb545b3aa5bb153b/git-cola-4.0.4.tar.gz"
  sha256 "910d939943553ef1cd8668af6058f1992d37cf0fe23d0cdef15ef8634e9b9942"
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
    url "https://files.pythonhosted.org/packages/b0/96/4f3be023cee0261b1f6cd5d2f6c2a5abea8d8022fc66027da8792373a57e/QtPy-2.3.0.tar.gz"
    sha256 "0603c9c83ccc035a4717a12908bf6bc6cb22509827ea2ec0e94c2da7c9ed57c5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
