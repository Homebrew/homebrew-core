class Libodfgen < Formula
  desc "ODF export library for projects using librevenge"
  homepage "https://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "https://dev-www.libreoffice.org/src/libodfgen-0.1.7.tar.xz"
  mirror "https://downloads.sourceforge.net/project/libwpd/libodfgen/libodfgen-0.1.7/libodfgen-0.1.7.tar.xz"
  sha256 "323e491f956c8ca2abb12c998e350670930a32317bf9662b0615dd4b3922b831"

  bottle do
    cellar :any
    sha256 "82f4fd01079c63a6c460bcc30030f5c3da384775f1a96b209eba0bfaef167e4f" => :mojave
    sha256 "8d75f3b5976c0415b4c99d78c185d086ed416a6a4a1ce6408c111193886efed7" => :high_sierra
    sha256 "5d3eeab26f1b61ae6dc105bb6612d339e188095e9633d9e19e08f98c9d9f2b92" => :sierra
  end

  depends_on "boost" => :build
  depends_on "libetonyek" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--with-sharedptr=boost",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libodfgen/OdfDocumentHandler.hxx>
      int main() {
        return ODF_FLAT_XML;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
      "-lrevenge-0.0",
      "-I#{Formula["librevenge"].include}/librevenge-0.0",
      "-L#{Formula["librevenge"].lib}",
      "-lodfgen-0.1",
      "-I#{include}/libodfgen-0.1",
      "-L#{lib}"
    system "./test"
  end
end
