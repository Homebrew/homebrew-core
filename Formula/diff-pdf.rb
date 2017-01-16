class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 17

  bottle do
    cellar :any
    sha256 "2b213ae3da945069b8392cbc60e0250e5c34f0ba2bd33073062682483f876c2c" => :sierra
    sha256 "738d3e9dd1d6f066c2ae52c9a5bc77f50ff68b93f9b254b4df00523459df717f" => :el_capitan
    sha256 "df95f62b368e52c54aaa7d2557dee32743b08c6b83bb2afd4a20f12b8e77ff03" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on :x11
  depends_on "wxmac"
  depends_on "cairo"
  depends_on "poppler"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/diff-pdf", "-h"
  end
end
