class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.20.0/fonttools-3.20.0.zip"
  sha256 "666c45681a56f7bc4b3cb7bef3b9bae334bbccbc00b41acb39f93f8fb5e60fdb"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec56994692fc19746a48dc7e5a06ca8f354f85b01a0af014a66acfb8216b4610" => :high_sierra
    sha256 "e142baf768019073315cc978b5fd5f2e601de31b464f36ab6c56b86c7312da36" => :sierra
    sha256 "c56073b8e6641cf9855341302b71db530bf76655feb1736d8aa45ce7dc2676f1" => :el_capitan
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
