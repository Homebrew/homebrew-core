class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.7.0/fonttools-3.7.0.zip"
  sha256 "cc3f0a06c22c21d0c88fb32fdb7fd2fea7c7d9cc0bdb913a46108fd65d2e4627"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87ace75102f2c622bad605439f06e84dc6edab79a057ef50dec6ca53591cf114" => :sierra
    sha256 "822622965198bf41c75487434af5e7d8d11f43d27f2eb6f81900032ccb3b0462" => :el_capitan
    sha256 "8f36a8f9b2c6e02ca80a07d5fec7da1d5468abc58c9528caee6d775bbb096043" => :yosemite
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
