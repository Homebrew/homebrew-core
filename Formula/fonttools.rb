class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.6.0/fonttools-4.6.0.zip"
  sha256 "18ebd83054995509584a542f70202f9fe8f0dacdb6eab3e132e96a067f9b09d7"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b7b372b00ba6db7d46dd31e57cac3fbe0009831310b127eba71a903380d36fe" => :catalina
    sha256 "b39f9d9964f6ba63f525cea800138f561f63581f15c2d446bdcc11fb5d9027fd" => :mojave
    sha256 "1ce14b4442a195e663b4b07bc020c0ae420f27f3ca04b510c3bb9944b3f290b7" => :high_sierra
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
