class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.10.0/fonttools-3.10.0.zip"
  sha256 "d165f83078a8f1bb9f466b12cee1ff402f39ebf143970762ef34abdb13fd4255"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "257540f8a8a20c637bcc1a9b58ca4cc238e9a5e5bcdb6c90469e86eb0cecc822" => :sierra
    sha256 "5e67db3593196cc727899b0864d60fb54c3fa499486146230443c9b714788114" => :el_capitan
    sha256 "4c381f702c44753b8765cf88d09663084da40acc6d5c64bb723da6b2c26e699c" => :yosemite
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
