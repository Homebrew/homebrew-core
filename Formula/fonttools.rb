class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.16.0/fonttools-4.16.0.zip"
  sha256 "1b9c539bf646209c3b60f0b143e8fd3650835ab2f12c5ba78a2f54e6ef5a1f03"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "48bb0b54fa915e5d6998f673992da8c8a5d81ad91f00c4f0de816b824b001549" => :catalina
    sha256 "02b34409b6c87831a05509fd35087a3e5776c70243cdb47dd219ca324f4f2e13" => :mojave
    sha256 "76b250c04d044252c9fd47df5541634f036664d780dee1c91f58fadba5daddc8" => :high_sierra
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
