class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.3.0/fonttools-3.3.0.zip"
  sha256 "fe06549f6d6f67e9098f2fc43c4037e9db08ee789ba5a4c82d4aa8ecaa0c5001"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd395345fa01dac0b8b70c9c6f9bf03ea2be252241b54e82077dec7d2044f0f9" => :sierra
    sha256 "e5b7c98838cebd09dcc42980ea7a6190bb335ec747cb19dd1b50accacea0ff3d" => :el_capitan
    sha256 "b82b20c5ab95a624cd0f1a8fff4cf3937e12f799bfe17e950a4206ad6f4dcb6e" => :yosemite
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
