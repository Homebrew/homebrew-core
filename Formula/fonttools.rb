class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.17.1/fonttools-4.17.1.zip"
  sha256 "7097b194babc05c8decfff6cbc81b184221fdcfbda568630fe441c63dadb3ab4"
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
