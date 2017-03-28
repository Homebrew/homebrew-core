class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.9.1/fonttools-3.9.1.zip"
  sha256 "8103938d857b395466cc341a58cbc8ae5a44e70dde900ee179567b04a41ff2d4"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cafbf69fab6dd63936d932c2e29ccc04b34261608f5f1fa57d56f12dc6ba060d" => :sierra
    sha256 "8f257065b9ab3dadac3e35196c3dccfd52a05b0dac5ab4a6f2470cefcf399b81" => :el_capitan
    sha256 "c35bdd3fc2258cc963e395ac9555fee418e26996c7516fd3fe6035e0756e34f0" => :yosemite
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
