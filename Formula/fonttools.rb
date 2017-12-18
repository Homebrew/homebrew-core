class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.21.0/fonttools-3.21.0.zip"
  sha256 "95b5c66d19dbffd57be1636d1f737c7644d280a48c28f933aeb4db73a7c83495"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c299903b648f99f2addb74400f9894a7c1daf1ec301e3ff7d14ad3112e343ffc" => :high_sierra
    sha256 "9cca30c67f0c05eae5d4348ffb300e4620ec352debb6727acb2183acce76fc6c" => :sierra
    sha256 "7d8d71edad445c4b94a31d5da57f952ffc19ca29695be169bec00e14dc0218c9" => :el_capitan
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
