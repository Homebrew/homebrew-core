class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.2.4/fonttools-4.2.4.zip"
  sha256 "955f5ba98b6f95778e3308010b196fa1a0d8862fb3ac75408919f5038e75e267"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af2062a6d2f5d138940adf33369eb40a2c3e2d21c1f4c53ec4e9611f4933cdf1" => :catalina
    sha256 "50e6ffef65c17d65a5c9a810b5a3354060026f0b3098f847e88dcbc12a42338e" => :mojave
    sha256 "5567045c1f8e84addc13c5d157f04c912252101ce436f81db5261fa5f4fb98f8" => :high_sierra
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
