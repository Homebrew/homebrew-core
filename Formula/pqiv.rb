class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.11.tar.gz"
  sha256 "ea1f8b6bcb58dee19e2d8168ef4efd01e222c653eabbd3109aad57a870cc8c9b"
  revision 3
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "6f1fac22db64a533a018f7a17969f7f1c860ae4c98353950a6aa9a60170b66c1" => :catalina
    sha256 "a9e56dbc25a1654cb12f1f4d1241008dbfcbac11d24105b50b382d3bc48e682e" => :mojave
    sha256 "556e01ad1e9c2bf9c3001fe2ed79c635a1395a2cc38e0c6525e94f6d6767e93f" => :high_sierra
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
