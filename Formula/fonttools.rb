class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.33.0/fonttools-3.33.0.zip"
  sha256 "f809b33c9124f6b06c9915bedb8c7a28c8201028e55546995e997937aaa1dea4"
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
