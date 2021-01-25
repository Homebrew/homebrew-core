class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.12.tar.gz"
  sha256 "1538128c88a70bbad2b83fbde327d83e4df9512a2fb560eaf5eaf1d8df99dbe5"
  license "GPL-3.0"
  revision 1
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "8c2f31429b5a944bffb089bcccb11f0cba5cb0dcf73621dead317e07cbd005f9" => :big_sur
    sha256 "dbcc8053ea8c57ccb4f05499a6be43381d33f7d8c795c7ff3debd097535179e1" => :arm64_big_sur
    sha256 "387f6de9e06e12374e1ec8cf2e1a3e0fc79c7a49a9cde3bf8425af0d5f034e43" => :catalina
    sha256 "1f6cfc90a6d4c70c37ae4e70754c5e8b585c1c7953c2284a31fec66900b6e525" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  on_linux do
    depends_on "libtiff"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
