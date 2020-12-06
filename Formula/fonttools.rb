class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/ec/af/760f22b73789c2b22deb37f6b21fee37fe5051740ede0b4e3f25fe8bcb28/fonttools-4.18.0.zip"
  sha256 "4e5b8bdf31f7c00248b42599eef761e57f2cf82884f83e992af972b84bac968b"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2f8dd58a70e8a78c9c603f57a6870b4d864324482d4340d1c1b24713ba7b633" => :big_sur
    sha256 "b9092af6bb6860e99363b24114ddf308d683024f1256170a57c092e47466d33a" => :catalina
    sha256 "842d5e0cd09948c59f295b38276d8db9b4d29974332747d13200da2c093fb9f5" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
