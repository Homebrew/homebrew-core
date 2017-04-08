class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.9.2/fonttools-3.9.2.zip"
  sha256 "7b0f3c2cd50a48c4ab080e4ad51ed4a7ef0a168d26433fbc7440afea8557257b"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bca425159b07b624608c5b6346ea59dc85dac8f03a537e394a2c50cbe33d5da" => :sierra
    sha256 "b801c9a93327211f8ed51e79537ee49e6c3e77a31dd04808c055af439141ff5c" => :el_capitan
    sha256 "51e53876aa9a31cd4ab109f37dd44ef134f1ec4e19c24bf7341b2efdd004b3d4" => :yosemite
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
