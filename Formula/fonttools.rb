class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.7.2/fonttools-3.7.2.zip"
  sha256 "3bb01af008e6ce56dfec4306249dfe8a235518f6221f09219dbf8690e3d16af9"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1396b8900b6b2a9c27a1bebd78082ac7583c3cb52365a9e4b310cb3d0250ecaa" => :sierra
    sha256 "2e69f8675e997cc1688e4b96c5d05c8b1a12cdeb8f066064c54cc7f394801947" => :el_capitan
    sha256 "384ebb561149362e1082aac9ba8817c548789d9315e1fd607c9d5e0753c7576b" => :yosemite
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
