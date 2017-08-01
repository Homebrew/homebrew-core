class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.14.0/fonttools-3.14.0.zip"
  sha256 "e67fff84ad24e546042f9a00f3ed7714a216944c6c7dde6de8b70fba6f5e7f62"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74e6059a72984c16e4e12defa56caff2e0e48ae93cd3605f94c6090e8d11ed3b" => :sierra
    sha256 "84e5b6a8cc5c52d988c95404726195c59186bb637a5d5e378aac8b9596e11e4a" => :el_capitan
    sha256 "3af56b703bcf6dd8c2597fed785d661f775dd0e31acf128997dfda20889a0273" => :yosemite
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
