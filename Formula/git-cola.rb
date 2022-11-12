class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/98/5b/b2966e7aa30b120fe20b2179fe1b20e3152a5618d2c6d69a21ca31b1fc49/git-cola-4.0.3.tar.gz"
  sha256 "bb9c7d5e9149eca61ac2b485ea38b881937d6d6eef3425e9c64a2590f8272348"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "061157d0e7df53f371f2d7193800a7c39d2a4db2a72e1ef6a11f7e6547e86f71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "785929bf797ece6d804c62b356b037cc37b9de5284bbc7debb967adf513f43bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fba302f55c6fa35ac29e762a7d0968ebc77c2ebde82b48f30c2b16c7016e645"
    sha256 cellar: :any_skip_relocation, monterey:       "d50bf78b98450192b017ab6784748f65a8e2befab12967c617b8fab13bb3ef3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "35133f6a7b3d03da9f972916203274462f383f1c96934f9d5f426e38c869d399"
    sha256 cellar: :any_skip_relocation, catalina:       "1e693c18dcfcc37959a708e7b1c647fae4074a22302cf656807d087ea7f40523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7c2d4f24c4a8f557a677d2f5a319dbf893a908ce31d7eeeeed564bf595caded"
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
