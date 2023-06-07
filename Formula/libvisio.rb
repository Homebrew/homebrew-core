class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.7.tar.xz"
  sha256 "8faf8df870cb27b09a787a1959d6c646faa44d0d8ab151883df408b7166bea4c"
  license "MPL-2.0"
  revision 7

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f94711a3b33d83eddf05c3cbe8eea0d2a6afac3b7306658c336b744df029d1ee"
    sha256 cellar: :any,                 arm64_monterey: "d6ef766bf3c121d58a6194476d823fd9bfc90561eb21b61899cd4c3ac27f70e6"
    sha256 cellar: :any,                 arm64_big_sur:  "8820ff95b0aa4116850ef496a48c90bf69f28530947c415a1bb6c7be6b618bfd"
    sha256 cellar: :any,                 ventura:        "3ab21490d5f4cd061d6007ed81a520ca3a8230e5562e354e6087ae1a0e0f4972"
    sha256 cellar: :any,                 monterey:       "8de26cd2912b71933a18250e906a002fe68b6454dc61673b02ace0d5e3d1853e"
    sha256 cellar: :any,                 big_sur:        "6759744fff649e44a3779347dd16510cc71d6afcb6e2a67f2447c2629e763fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82e1fe6538a4513b666871e69ba62cf390916dd8e5f66284a5bbf8c31b15f776"
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
