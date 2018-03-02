class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.24.0/fonttools-3.24.0.zip"
  sha256 "d09126f443bc8797d1b7e76274e65f4c169c04722745953ecf536451b1d9a15f"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80b3654d2b32a50d031c33f3de776adc819b411703384ed724dbe3ca5755c072" => :high_sierra
    sha256 "afab3c5d1d7ef8416b815564dd2b2751185bb25e409b6cf8e3789bdbbf70e7ed" => :sierra
    sha256 "fea4bf4f547cede93550aa72aaef06095ef7625d5a18172a001dd38a3d833deb" => :el_capitan
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
