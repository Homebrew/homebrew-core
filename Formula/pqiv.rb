class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.4.tar.gz"
  sha256 "58ddd18748e0b597aa126b7715f54f10b4ef54e7cd02cf64f7b83a23a6f5a14b"
  revision 3
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "b1dd7b8cba6ac196be3980c9d147b21089289334e6557b1fb0542f760327ada7" => :mojave
    sha256 "c6f9595369e2865fa3413a46a370c2d8b6361b57daa4d63f5f3e098630aaf100" => :high_sierra
    sha256 "e4bde7ea48d108d4b900c3ad63d2d5bba239a8e2384ae41ed940d71bff697fd4" => :sierra
    sha256 "e9d41ace28faa83febe6470600deeba614847a105d4f2ba11c06e41e19b11a18" => :el_capitan
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
