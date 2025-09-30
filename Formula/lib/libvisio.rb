class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.10.tar.xz"
  sha256 "9e9eff75112d4d92d92262ad7fc2599c21e26f8fc5ba54900efdc83c0501e472"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d34ba1e9dae19527ac52a22cc1081310a0a0b2cc6e607489bc62ef86f0654cf"
    sha256 cellar: :any,                 arm64_sequoia: "72aff8059d8e95c141aa55e4a0b37f09eb0dbcbb1dd809e3f71eb2a8ee50a51e"
    sha256 cellar: :any,                 arm64_sonoma:  "b85d1b6f042c1ab45355546c36f4251b0772aa595e651c228125b04c847cdbc6"
    sha256 cellar: :any,                 sonoma:        "5a8927f9e698dd331775a10ed3743b4ebf1d900b6c3bccfab38e53ade118727b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bf003c70b70c9bec2be08384ee46a031b30940de8567ccd85f7f82daceda50b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c3b2ced8dd68a25d81eb65260b29e7e978c88803a0cb2e98b183bf1f9cd8adf"
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
