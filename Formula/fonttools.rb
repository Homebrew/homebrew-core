class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.41.1/fonttools-3.41.1.zip"
  sha256 "66d7e33aed34aa14fb4c4f63538a4717690c5ea2e5593e8bfa7d4d9b4e4c7b72"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9d106af745e57ef7ecc41b55bc37d759d47663eeb2aaf5958b70d4f95fa0efb" => :mojave
    sha256 "bc33d8ff96280a36b6c86a51fc2dfa9ab04a8a69fd606d14a42d4bfa3d089eae" => :high_sierra
    sha256 "1d843962f5a81512e2ac48e59b4cdd2d20eca616239689898362caf37c2c33f5" => :sierra
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
