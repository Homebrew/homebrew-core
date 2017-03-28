class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.5.tar.xz"
  sha256 "430a067903660bb1b97daf4b045e408a1bb75ca45e615cf05fb1a4da65fc5a8c"
  revision 2

  bottle do
    cellar :any
    sha256 "ae278d471d1d7186905d705c4250bf3fe93e7fffc8819e33b357e52de3b9fe13" => :sierra
    sha256 "265e259be67cd149b2b9a6b56b15e51f0e7f4b401e2c0671c2cdf7dca72a192b" => :el_capitan
    sha256 "d71a0ec9ad1fa8ea8775332c809ee202d9b7049f546da2a89021055ad8a3c696" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
