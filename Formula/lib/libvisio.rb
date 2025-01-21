class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.8.tar.xz"
  sha256 "b4098ffbf4dcb9e71213fa0acddbd928f27bed30db2d80234813b15d53d0405b"
  license "MPL-2.0"
  revision 1

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c15aee39fd82305afa238f8b1c75202284ff9b0d5d261226343ffcd53cdb0064"
    sha256 cellar: :any,                 arm64_sonoma:  "983ffaa320faf381b16d3f1593ba000e7d8e18cbd39501a06191a6f29c553a36"
    sha256 cellar: :any,                 arm64_ventura: "0f6f5116ca551ef8b0f5139d49de28f4e45fe192954f38ba4606608f17dbb3b4"
    sha256 cellar: :any,                 sonoma:        "6a5606558f7bf409f7efd1787a1337895d2b2f4db4cf256a8b138e5f0114322a"
    sha256 cellar: :any,                 ventura:       "f954859d9ab8bac097995131b4322e10cbe544fe2fc21f75493b0fd9b04d0334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c94de8e456f793629b0325a003292735f212e9ddcdd18dee9dc3f6c74845981"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@76"
  depends_on "librevenge"

  uses_from_macos "gperf" => :build
  uses_from_macos "libxml2"

  def install
    # icu4c 75+ needs C++17
    ENV.append "CXXFLAGS", "-std=gnu++17"

    system "./configure", "--disable-silent-rules",
                          "--disable-static",
                          "--disable-tests",
                          "--without-docs",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <librevenge-stream/librevenge-stream.h>
      #include <libvisio/VisioDocument.h>
      int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libvisio::VisioDocument::isSupported(&docStream);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1", "-L#{lib}"
    system "./test"
  end
end
