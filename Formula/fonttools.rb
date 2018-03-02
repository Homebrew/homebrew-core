class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.24.0/fonttools-3.24.0.zip"
  sha256 "d09126f443bc8797d1b7e76274e65f4c169c04722745953ecf536451b1d9a15f"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0436c59dc2f262ac2157e49ffb96b67947ddc0c8eaaebb959e902999cd5bf08" => :high_sierra
    sha256 "7e94717fb5591da52656ebe6f5ac8c715de35c69e7bc8c97d6c53de2a82bb9bc" => :sierra
    sha256 "0a4fa59a945005c6d129c1c83c0b1f503e6dd8b116ad03bb059e94c361c036f4" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python@2" if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
