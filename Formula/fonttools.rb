class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.11.0/fonttools-3.11.0.zip"
  sha256 "b9f0c93914d83f27b32b5eb89c640ce1f1cb6f8466bff6079ff27903275f8994"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80f411cc801c5bd9eb628906d803c0104264da426cd7877fe49b15a54570d2a2" => :sierra
    sha256 "afeeb89590468e228105c677af855d1c6f290211d08a9b667fa243506dcace1a" => :el_capitan
    sha256 "cedf788f998df47cfd9b7a1e903576ac0a5d5557c98a4e71eb1710aaf8801eac" => :yosemite
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
