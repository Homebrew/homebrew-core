class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "http://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.3.tar.xz"
  sha256 "943e03b1e6c969af4c2133a6671c9630adf3aaf8d460156744a28f58c9f47cd8"
  revision 1

  bottle do
    cellar :any
    sha256 "ae237de01eea21154d18eb861b652db51f7f8dd2c6912400b27f2e7ccb7bae9a" => :sierra
    sha256 "a9ef7b2ac1d7873b9c879c42a7454ff752c5c2ef4e7a23606583ebda16dbd794" => :el_capitan
    sha256 "95f0b0f81bff5bb91978bb2599869fdd435e78abda6bd56933d28fc03a11de45" => :yosemite
    sha256 "a5e3178d3edbe400b534236897bd148daecdf5dd2e05939a4a87445927773ce7" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "cppunit" => :build
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
