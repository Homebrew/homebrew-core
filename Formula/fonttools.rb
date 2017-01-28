class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.6.0/fonttools-3.6.0.zip"
  sha256 "c2692bfbd93038b81da888308710b97aabb2e33cc1ea0f7312dc31937996722b"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5765f87d6884cce6d059e0c0dc84534cad1cdb688ab87b674dd187d2565a340" => :sierra
    sha256 "b98afd05303c97dd8988fa2f04796a6791c151efc2c64279e3aa736d64b93b3f" => :el_capitan
    sha256 "2f47505da0307720d677075c79893873395c58d12ea809379cef16c6b2ff0400" => :yosemite
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
