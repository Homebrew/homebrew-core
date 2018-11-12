class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/archive/3.32.0.tar.gz"
  sha256 "1e328ed8dec1de53140fef2c8052f4c97119914f95f39927378c1c4b75afae44"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e0fb0bdafcda9d5f22ff1f3bbc001bbb9310e7bacac396191354956df893e2a" => :mojave
    sha256 "b87836b5938a00dc57f4455594186907d41a02f2c43a2a76c7be486812c1c2e0" => :high_sierra
    sha256 "49e67d16605778f4a10ae5978bd1b129a321a1ab98d10010b2bccdf3d6b2cd6b" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
