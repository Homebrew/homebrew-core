class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.6.tar.xz"
  sha256 "fe1002d3671d53c09bc65e47ec948ec7b67e6fb112ed1cd10966e211a8bb50f9"
  revision 1

  bottle do
    cellar :any
    sha256 "636f9fa0f3ee0eaa03f4102bf8e1d03cffea884fc727994051f760d8829b65ed" => :high_sierra
    sha256 "4fe8c91165cb26818326c4e394f71641b7e06cc164287e78822461e95a2691e5" => :sierra
    sha256 "bdf2da4a3f76d0f12d32a4d9854ed49ddbfc85cefd9feb354027a16aa5deb869" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cppunit" => :build
  depends_on "boost"
  depends_on "librevenge"
  depends_on "icu4c"

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
