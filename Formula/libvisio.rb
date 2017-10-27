class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.6.tar.xz"
  sha256 "fe1002d3671d53c09bc65e47ec948ec7b67e6fb112ed1cd10966e211a8bb50f9"

  bottle do
    cellar :any
    sha256 "c096d61b9dc4d6d26abe57ff3e4a1e7c2c5da676d7499c8aa06dcab955befce8" => :high_sierra
    sha256 "9894215e290f7c3d7a646d611bbe96402d9ff88109301d3fafb8907ed5e13198" => :sierra
    sha256 "af2275a2b29de1e2b5d4e2e281d00d713c34ee1e0264d84cf293ccc4a95f25b2" => :el_capitan
    sha256 "0084f97aca06e33026de34970f87f69547d92f94a5237a9cf587c18ec63c452f" => :yosemite
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
