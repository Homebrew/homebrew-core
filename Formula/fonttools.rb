class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.14.0/fonttools-4.14.0.zip"
  sha256 "65744b52eee9da4e6ece77e0f8be1f79ab75f30d0b161ce667e9e2e2ed00b0d1"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca4cebdcc20adb4a2baf2d046bf473442ccfdb0e5b0fcaf29d3d59e41191a402" => :catalina
    sha256 "b6a07cdc0477ecd7b33280284cebb828561545b7eb2596cb02043c34eb5ca2e2" => :mojave
    sha256 "ad3109af81809ff975094d7cff4ef352b4661e20f3a419e3ff9e97997c31fcf2" => :high_sierra
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
