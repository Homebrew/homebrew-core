class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.10.0/fonttools-4.10.0.zip"
  sha256 "59c58444267685335ad5a347cf45dea119244be34a9e86adb63354b703549749"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7f128c3911235f8e914ee83661f7d04c8fc152ec7590dea8bc1ada9581cc02d" => :catalina
    sha256 "1ba05c6a7d061805ac74621a1c186e723a3dd3c532cc2a5e18cd04445eb83163" => :mojave
    sha256 "a455bd2ca61d13347c18197f10b8425ea87912b56485097774ce6ad37f51b036" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
