class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.11.tar.gz"
  sha256 "ea1f8b6bcb58dee19e2d8168ef4efd01e222c653eabbd3109aad57a870cc8c9b"
  revision 1
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "4d653add742b4a25773c2d0e951e67c5000e0c82f121f2680c68bdab91d95f10" => :mojave
    sha256 "07caf0286e9986943857af749783ea5330d7f757a9446d4c1da4edb8816a3a2a" => :high_sierra
    sha256 "90f6112ccb462622258370e158c86af8888fc97869358e8c0e3a7b7ac39c22a9" => :sierra
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
