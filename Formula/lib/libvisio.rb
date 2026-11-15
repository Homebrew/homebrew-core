class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.11.tar.xz"
  sha256 "2a6efd40b6d9dbcb70fba3be53112366882ba97b57151df3698dfa478c8d8dd3"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f6c46631395a9695cf7240e38290ebe11e4932ae6f569d1ebf0925e888d64f6d"
    sha256 cellar: :any, arm64_tahoe:       "536572b5add38a100515efc8e55de85eaedfba4736a9121eaa7307bd52891a5c"
    sha256 cellar: :any, arm64_sequoia:     "7b612c0a6c487ac18f4665d020a5df3c2f62f5b4414d1daf65f80f3e94a17557"
    sha256 cellar: :any, arm64_linux:       "209a7ab01a37b20cc8067759e0cc3ad150826a7dbecb18ddcaa643d15b25ce03"
    sha256 cellar: :any, x86_64_linux:      "b4ef239f44233e716211b36fc5eebb8d5abb664edcee44d12734f80ed2b17e66"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@79"
  depends_on "librevenge"

  uses_from_macos "gperf" => :build
  uses_from_macos "libxml2"

  deny_network_access!

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
                    "-I#{formula_opt_include("librevenge")}/librevenge-0.0",
                    "-L#{formula_opt_lib("librevenge")}",
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1", "-L#{lib}"
    system "./test"
  end
end
