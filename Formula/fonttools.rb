class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.41.2/fonttools-3.41.2.zip"
  sha256 "2f0236403c76e29e5dd4ead7a22e7ef6e425b1bae48461366166c68d813d4384"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63a193240f88353bb4dcf3b3c92280b9c0f3d78384b464b8030946faf00c486d" => :mojave
    sha256 "6bce54e99f146d99a380cf093dc04d589aa9602f249a0e12ad13563111d13b7c" => :high_sierra
    sha256 "3e3e4b736e211711bfd67084622f5f0cb09cd19444439a8f84bd91e407c63c5d" => :sierra
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
