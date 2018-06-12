class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.27.1/fonttools-3.27.1.zip"
  sha256 "a81b57be6c9b556065d7f67a9ba4eb050c5074590f933d4902cd6ef331865aee"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c2146fe7577d32f7a19ad4eb879eb9dbef179dc760f54bec2245d9388548945" => :high_sierra
    sha256 "b58d3539150972ce0e212dccd9b2838b5c58aecb2bc4a5a8c191316af55992f2" => :sierra
    sha256 "1afbb7e4bd57721758604d95ddb31bebc4759f3591eb4218b4f25f2714de2b82" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python@2"
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
