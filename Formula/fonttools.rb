class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.29.0/fonttools-3.29.0.zip"
  sha256 "aab38c8c131670684321437d4857dcb4de1c775efd152a9ca9c4d81f1cb97fe7"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1472bd3b96a34e11930b0344a082ca3a74cd0031a125610d217fed6e75661d91" => :high_sierra
    sha256 "f9b15f066d6b581055d0ed4f6b0e0158817571009fcfc04345563e8964fa9133" => :sierra
    sha256 "025d383d27aa8c3b6dabead6c6b104c794010ae4e08de9f87f343702458aa010" => :el_capitan
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
