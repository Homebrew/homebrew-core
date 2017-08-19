class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.15.1/fonttools-3.15.1.zip"
  sha256 "8df4b605a28e313f0f9e0a79502caba4150a521347fdbafc063e52fee34912c2"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae5179a9e845d6148599dd82cda518cc3b38e561f20a75764e1442f0fa766368" => :sierra
    sha256 "7413018805b441f41c2033e3b4982769afbfe34b36e0858593b305f84b86a01f" => :el_capitan
    sha256 "1f3c01a385e2517c4b7d01eca7d5505173d310e8d6128187d8056034fdbd3bb6" => :yosemite
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
