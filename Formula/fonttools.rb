class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.16.1/fonttools-4.16.1.zip"
  sha256 "991eb05e0366af5a6e620551f950a4f49433c5a8de70770a7066bcbe78bb86cc"
  license "MIT"
  revision 1
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3116030d9a1bab695e37d00aaacfb318e58153e10573df97253707a2ef95f2db" => :catalina
    sha256 "1f0513ca70e8d581487c70736b356e62a4c4848ce902e7ca83e53aec33c17010" => :mojave
    sha256 "053e21027d7633d0263041c6c221bdcabbc713e41120a1d6004988eba114ef74" => :high_sierra
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
