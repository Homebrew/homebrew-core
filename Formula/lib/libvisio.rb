class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.7.tar.xz"
  sha256 "8faf8df870cb27b09a787a1959d6c646faa44d0d8ab151883df408b7166bea4c"
  license "MPL-2.0"
  revision 9

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22d954a005f6347ffb3eb64773d44fd20975e26f07319b9c89b1e9796f413ee5"
    sha256 cellar: :any,                 arm64_ventura:  "17ee6d60a92ea6c59eea9155b255b4c6c2cb532e565b0f689af4f317032e369f"
    sha256 cellar: :any,                 arm64_monterey: "b602b9736cfc5a72c9d0c6ca1e40c1f64dcb04b3f2b87878c66f721fb48833ec"
    sha256 cellar: :any,                 sonoma:         "8025f333d26ffd42ae0ebf5b8197268ef74e0b0bada7f8d2879673dcaefe03af"
    sha256 cellar: :any,                 ventura:        "c7e5fc5dafae638ec9d57e594ace220b349bf2e3f61bf611b38b830dc2f17bd2"
    sha256 cellar: :any,                 monterey:       "8a6e5d7c6a9f8ce1a3fc1d5783f66f78027209310728ba3f3f1d921a6ae44cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad23bfb3366f55886db7ca0b460b25c41fc30efd35af8c3d724e7723234eb573"
  end

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "librevenge"

  uses_from_macos "gperf" => :build
  uses_from_macos "libxml2"

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
