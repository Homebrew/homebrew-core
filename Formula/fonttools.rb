class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.38.0/fonttools-3.38.0.zip"
  sha256 "90d6a51a512e69daa3dbf1e418911ed5939447b02827bd42ee6feaa3c7bc318b"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b820dc8de84bbafb401633cfdd367b3e60baed238672f58d2ec7858c20ec4cca" => :mojave
    sha256 "3ae99498d300dddce3c4fba48c159fc654b1d2b3268aaaba58cef51f061b26d8" => :high_sierra
    sha256 "42a149616f0b23745bff2478b8df0a00608d02c4b4074377b0802aecb51b0e8d" => :sierra
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
