class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.10.tar.xz"
  sha256 "9e9eff75112d4d92d92262ad7fc2599c21e26f8fc5ba54900efdc83c0501e472"
  license "MPL-2.0"
  revision 1

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d21f8260dc1cf5d5d02afe609b97470e1ead480092f91357952bbac5dfdde368"
    sha256 cellar: :any,                 arm64_sequoia: "96a23a4cb67c3c5da5d2bece12cab4ac28ca428ae147fd745d82f727ab735d02"
    sha256 cellar: :any,                 arm64_sonoma:  "b0b74a78ef0df049e17fa445170740bb3473645218e601eb5e2c61d2ed9b8c6f"
    sha256 cellar: :any,                 sonoma:        "433041fc1f51912b52c97af1eef4d7d28393d9d7a74cefcb649872db63046a05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d529ab9200e06d77a9d6eb2442530b67890028159d455bf606c0710392244f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14261318fb42b0b53b27efc301702f60f49b36cf8c6f11ff86777bddbcf4ca91"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
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
