class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.17.0/fonttools-3.17.0.zip"
  sha256 "1c4f26bf32cd58d5881bfe1f42e5f0a1637a58452a60ae1623999f3ae7da0e24"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b06ccb7f0ebc6ba441dc5300ad361f2030b808d0dbd553d573be98e8f4628f74" => :high_sierra
    sha256 "f8504991decff26c80545d390303ec36b84722956474f01eade359a69745966f" => :sierra
    sha256 "219551cebd8cfcba224f996bc33c80edcd39b994788b5cec75b3562fd313c5a4" => :el_capitan
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
