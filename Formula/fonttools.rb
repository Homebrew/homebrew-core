class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.43.0/fonttools-3.43.0.zip"
  sha256 "147e047779c57b66ce827f04b9336f040b19f38b3164a688311e7de7af7180fa"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "29ba172e022a606282fe847d89af4d6b14720c91344ccb2dde3134193b197d59" => :mojave
    sha256 "9e4d8ef905e68613b945aa13bbd870e14c2a1b0b98987c497e16f9917aa82d7b" => :high_sierra
    sha256 "c525b67c68ad8dc18a603ab11274f836474fe59b7281a212d230f936db18adc4" => :sierra
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
