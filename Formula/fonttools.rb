class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.2.3/fonttools-3.2.3.zip"
  sha256 "884939969e8a207648d7d85a4bc9b0c113857c689f1c1a9c5ffdd374f822d046"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f882d11851700f8c9e30da18a8b55975c6e33391b78630ebc321d64adca84f4" => :sierra
    sha256 "fe9e18696b3838f6701ba776b645a71db7e2c52bad47baa7c2a94b0a2dfcf4c4" => :el_capitan
    sha256 "cc80a9ec7e694e1d918cbd12920263ef808c3a336b1b8624f720e789615078c3" => :yosemite
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
