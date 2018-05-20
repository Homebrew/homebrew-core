class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 30

  bottle do
    cellar :any
    sha256 "9ee3f39da8c432adacee20454ebb57c09cb3a1cf4241b1d7b427a23bb0a40b42" => :high_sierra
    sha256 "101f7e6636915bbecfa2e6258beb8b8ae5a784d79dbef934bdd3394efa80e99c" => :sierra
    sha256 "138baf9a0dc5e9793a113e9dc8de3a3fb6a0a0c28e52df5911d2694112c9bbdf" => :el_capitan
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
