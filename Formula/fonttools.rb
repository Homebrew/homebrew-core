class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.21.2/fonttools-3.21.2.zip"
  sha256 "96b636793c806206b1925e21224f4ab2ce5bea8ae0990ed181b8ac8d30848f47"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76bc5b800161c11f68770101a85df5539008aed5b5d7ff4cf3815f9d13e49f87" => :high_sierra
    sha256 "2d0570cf3496c8850be8092f08615c61faa5b0e5e34dd393b96d991f52c1d790" => :sierra
    sha256 "30eba417de8d2c647f8f904540da19f9a25c96a4925c2283076a0b32a30a227c" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
