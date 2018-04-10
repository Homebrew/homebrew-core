class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.2.tar.gz"
  sha256 "920a305de2190665e127dad39676055d4d7cdcc5c546cbd232048b87eacee50d"
  revision 2
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "c0ab85b5ba25d991344a88a1154c2c789f89f96733cb02735cc3b0ea7226b615" => :high_sierra
    sha256 "f02c4d9362ee74eeaa25eab1baba7967bd6b31d3ba469fd8d704ebf7aaac5e00" => :sierra
    sha256 "9e96bf572f6cce9f960f274077064d7e22c15b4b4f91ca23816fd797218d7610" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libspectre" => :recommended
  depends_on "poppler" => :recommended
  depends_on "imagemagick" => :recommended
  depends_on "libarchive" => :recommended
  depends_on "webp" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
