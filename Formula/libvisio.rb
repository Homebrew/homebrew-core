class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.6.tar.xz"
  sha256 "fe1002d3671d53c09bc65e47ec948ec7b67e6fb112ed1cd10966e211a8bb50f9"
  revision 4

  bottle do
    cellar :any
    sha256 "d36591665e4cc9c4af45a9372e0e2749c1beaaf07bcf9783d31c4b305465f2b7" => :high_sierra
    sha256 "9dc03aaa376fad416fd3f0532640ed974429a7738d69e149daa5cfd590148ea0" => :sierra
    sha256 "0f4354fe1d3f35c51cdcc66bae90a25c206574305407d102fd82c760def847a0" => :el_capitan
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
