class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.6.3/fonttools-3.6.3.zip"
  sha256 "0525aaa38f9a7b5381086e2843892ec764585ac623af042cfb86e1814bc1229e"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d21ce7c75de8e1c25dd93db9aae66df4881c69abba3a045aee829c30aef2d206" => :sierra
    sha256 "7718b115ac64a5739791a8690ff9194686d716a9c9e6e739b8e5471da1c061a4" => :el_capitan
    sha256 "94bc693d769ccf9cef028b00f2fda5b3ef9a313928ab2aff8ce89a9a12946a7a" => :yosemite
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
