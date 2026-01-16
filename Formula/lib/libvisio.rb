class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.10.tar.xz"
  sha256 "9e9eff75112d4d92d92262ad7fc2599c21e26f8fc5ba54900efdc83c0501e472"
  license "MPL-2.0"
  revision 2

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e241eb77c998c706f44a477749306d05bbc0b8217679cba715b97ede9f9ec2b6"
    sha256 cellar: :any,                 arm64_sequoia: "9cdbc5cb4a38eb26f6d184e381df163a62eba6f29611c4f7e7be3bd2b0658ec7"
    sha256 cellar: :any,                 arm64_sonoma:  "e392fa4282309aa0d095e2a736a1f4e390d74d072edbe27e8b2451779fcdc750"
    sha256 cellar: :any,                 sonoma:        "26419e2bf884b48b7d94dfdf19de9bbc8f118c89585f1d83818b90e46742c867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f05a917fed1e4685878ed8b3821a5ba5cfc481ce5f4dca4ec6195bb985e4b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d9ebc9fa47e7fb49aa8d379935dee191957a24dbabb7b40d23ec0c0bd76159"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
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
