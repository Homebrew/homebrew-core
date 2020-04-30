class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.7.tar.xz"
  sha256 "8faf8df870cb27b09a787a1959d6c646faa44d0d8ab151883df408b7166bea4c"
  revision 2

  bottle do
    cellar :any
    sha256 "6b8a940fc5c5a3c3ed2982ff254732b807f26446e34dd5668dbf626c26a1e19d" => :catalina
    sha256 "648592e9cedbcec5f4250497e22495133cf8ee7ff4944ff28e15c7654f99cc1b" => :mojave
    sha256 "4ec8f527f10a7220aea4e4dbfb6ea599a3b8f8910109378dbf6359d29085f2b8" => :high_sierra
  end

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "librevenge"

  def install
    # Needed for Boost 1.59.0 compatibility.
    ENV["LDFLAGS"] = "-lboost_system-mt"
    system "./configure", "--without-docs",
                          "-disable-dependency-tracking",
                          "--enable-static=no",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <librevenge-stream/librevenge-stream.h>
      #include <libvisio/VisioDocument.h>
      int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libvisio::VisioDocument::isSupported(&docStream);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1", "-L#{lib}"
    system "./test"
  end
end
