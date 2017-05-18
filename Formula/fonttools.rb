class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.12.1/fonttools-3.12.1.zip"
  sha256 "026d78e87fb5243d536fb19c03d293f080b82f156f48da92df1c1c7f02177cbd"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddab640cf1ac0714a1db7f03c024974d1d3714540cb24dac4eb03f37c7f72788" => :sierra
    sha256 "8017ff740806bb1a530cf448f20d1ed8d334e8d88bb3ae73f97df38ef861fe2a" => :el_capitan
    sha256 "6c527e930af3bfec0567dd472943b2abd0d97c0e290a5b26de95946e3515c30c" => :yosemite
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
