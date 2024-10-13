class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.7.tar.xz"
  sha256 "8faf8df870cb27b09a787a1959d6c646faa44d0d8ab151883df408b7166bea4c"
  license "MPL-2.0"
  revision 10

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ebebaceb54777a026f7a0cfe6e3b9282dc40d359416a0a6ab9236ac0faad4d02"
    sha256 cellar: :any,                 arm64_sonoma:  "fc2b2c30cf2e3df7f21a9b0518a454c1490182f555c32e80db1a944b1323991a"
    sha256 cellar: :any,                 arm64_ventura: "84ba4a807fe220d9226d6de48f093c3c9eeb68d55d6026cbd2829454b7294158"
    sha256 cellar: :any,                 sonoma:        "789b83140d9161fe4856e7c6c5dba97dea622c2ed05d736dcb0b99195f21f2c9"
    sha256 cellar: :any,                 ventura:       "c6a08f0171c8df5718e886f36b8285d8701ecfce6c6c5d439c088f4d69b559fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c864ef2b4a42cb7e3b1b7aea3c8c0c3eb79d4df2de9ac3e1ff747c4d3ba6072"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"
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
