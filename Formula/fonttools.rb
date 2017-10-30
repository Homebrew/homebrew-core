class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.18.0/fonttools-3.18.0.zip"
  sha256 "f1a61cb4219d4acd145a12f19a01245367172dfa4d7da0e2f1f582b29d0b4fd7"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "86f29faeb2772af49751004c9587702858c069718759e4b76ecf0ec552f5f7cb" => :high_sierra
    sha256 "4e0af7c4075457c03ac3883fa7c85391f87555a536cb6672d90918517db64837" => :sierra
    sha256 "2d28240b52d64b2816306a42fcab91319d167d3f03313749e77e3d447e987311" => :el_capitan
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
