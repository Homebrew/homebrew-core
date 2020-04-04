class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.7.0/fonttools-4.7.0.zip"
  sha256 "ce977f10f070752301e2d49ed822cfc860c881046d81c376fade1e6529b2046c"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8062a330abf571b3df8d3492452bf70b1776dcfe6fbee329d6a5cc472373ca11" => :catalina
    sha256 "0241a9210bedb9f9e3c314c2feda829e50abc7ca3e9703c198e3274454826001" => :mojave
    sha256 "cbb7d6cbd4cb95c835f61da8737460023c6536bc07c239550ee6525364683dbe" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
