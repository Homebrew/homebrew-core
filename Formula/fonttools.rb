class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.21.0/fonttools-3.21.0.zip"
  sha256 "95b5c66d19dbffd57be1636d1f737c7644d280a48c28f933aeb4db73a7c83495"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac5b2573c00b06074d53fed8f7c227b418fbe31eb3e8fceaf60ac293cfd89db7" => :high_sierra
    sha256 "83e6ce18464bc336cfa28639460770cf7fac3954be0f069db1e9a9a9a9becde4" => :sierra
    sha256 "51190053bf3195b780379cd2b36617dab50809d19e8e02a5bbeecbd83b75b4be" => :el_capitan
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
