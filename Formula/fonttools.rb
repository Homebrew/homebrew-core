class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.13.0/fonttools-3.13.0.zip"
  sha256 "5ec278ff231d0c88afe8266e911ee0f8e66c8501c53f5f144a1a0abbc936c6b8"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d0dfce3e34fe445074e898fa96ba7045a71de85fa0423b816bebb3a32102a5e" => :sierra
    sha256 "8f3a368c100f7e54154a9b12b6e2e220014b1f98af5f6b7383445578670a0fd7" => :el_capitan
    sha256 "7c22d693484aca204d7aef2054829087a33162f3d8c5245b82355cfed60de479" => :yosemite
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
