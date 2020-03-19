class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.4.3/fonttools-4.4.3.zip"
  sha256 "f5b014cc20f26bc812818330e3ac00db612721d1f24f98db42b40c307c2d9205"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43faa90c85358627628b8303256f88ad29da4c4f3b5ad33e0175df6317c1df9a" => :catalina
    sha256 "e2a30d9d5c57c60d94657fcc99804677d7870ce0d72f2723b9ebcfeac97f6527" => :mojave
    sha256 "bd5b1530cfb642dd0313520413ac3deeab6ffef50fe7482c74019be0bfe78b23" => :high_sierra
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
