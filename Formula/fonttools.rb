class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.38.0/fonttools-3.38.0.zip"
  sha256 "90d6a51a512e69daa3dbf1e418911ed5939447b02827bd42ee6feaa3c7bc318b"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb9a3f0516ec5f72349411ec5d7c9bf8589a8b3b72d0450a86105beec402a9a3" => :mojave
    sha256 "45954f4cbdaecbd6370ed1733ff262a61f15b292e6919584d6b83cb09c4001de" => :high_sierra
    sha256 "404d6fd4e3ddd02962f74c6b25894cc6749646a02ea17ff3dfddfafb77efd810" => :sierra
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
