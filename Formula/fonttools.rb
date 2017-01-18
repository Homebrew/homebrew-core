class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.5.0/fonttools-3.5.0.zip"
  sha256 "5e40ae84f74630c5610822f808e971e4c6898110bf05d29a96bae6d20ef7e387"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f96a2adc34c3b432f1516ec12c76efaeb8a812c598b02f387fb12b56f2e04bfe" => :sierra
    sha256 "c3783fe031a23848c1e3e0adc9b69125a053259873b66cd79647835fba1407b0" => :el_capitan
    sha256 "9b54aafd2a3d401e6df4e50d211cf0a63d7cb1f7f182a6a4b6e2124f0279be7d" => :yosemite
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
