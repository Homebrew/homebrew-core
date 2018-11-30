class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.11.tar.gz"
  sha256 "ea1f8b6bcb58dee19e2d8168ef4efd01e222c653eabbd3109aad57a870cc8c9b"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "bb4071cdad65798b3ab3c1c55f7bb4e3ad42d17baebce931b3c49962cbf7afae" => :mojave
    sha256 "9c6b2cbef946577e7736a9e3a5926808c66034e58a44fc0002cc83459e0b526a" => :high_sierra
    sha256 "25d7864b81b2bd292a14ddf46ad855244f8821b4f290eb222b8e674fa388c617" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
