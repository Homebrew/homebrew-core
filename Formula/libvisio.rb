class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.7.tar.xz"
  sha256 "8faf8df870cb27b09a787a1959d6c646faa44d0d8ab151883df408b7166bea4c"
  revision 4

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "eb2af5e8a4c4c1289e4b8e1db77de18ff78c99b0f6ed68ffed3d6c3a2cb0abc9"
    sha256 cellar: :any, arm64_big_sur:  "9dbc60f38f0b2cf07e5df55fcc4a67d9d31a8698cfdc8f411b269d1e3daae0bf"
    sha256 cellar: :any, monterey:       "131e5afcfde4ba63620ca6820c657209e1f4c51dca3b95cc3db4bae23bdddb0a"
    sha256 cellar: :any, big_sur:        "09a9e29742cf5667ad9f935a7d686641b54383c1ff8d5581c1a7c145a966760d"
    sha256 cellar: :any, catalina:       "e431e0e6e96f2ac918d37e4e10f264cf23b7af0dbc54d3f82ab80b309efbd079"
    sha256 cellar: :any, mojave:         "af67f5b493aebbe8c072fd0254e47bd8b205a00eb29049ea38046a9065fe8876"
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
