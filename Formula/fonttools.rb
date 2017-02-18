class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.7.2/fonttools-3.7.2.zip"
  sha256 "3bb01af008e6ce56dfec4306249dfe8a235518f6221f09219dbf8690e3d16af9"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8749a16208d8284e3c8a8157164984fb72ec22eba073515daf00547351bf508" => :sierra
    sha256 "e19a11de82ef358a1e7382d1b94e06ff6a47ead70b7ed637f2520da14d1911c4" => :el_capitan
    sha256 "25c9cdd53695700b9f655f94a03701a75eb2f5405a987dc23ed922035e2f08fd" => :yosemite
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
