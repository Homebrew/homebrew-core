class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.41.0/fonttools-3.41.0.zip"
  sha256 "d0113965f0c31717a8a585184ae449cd35c103d5f26516a5ced378de944e78b8"
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
