class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.12.tar.xz"
  sha256 "f59fa2e3baf95475256fe84ea0aa1214f43940bae94424f4026b2d633933df01"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1ba55bc6d363dfb65454fd5f2ef269b6164ac924136f67554ab0f204fc34abb6"
    sha256 cellar: :any, arm64_tahoe:       "2e6e55f0f80404a0239a22f61f424b28cd377312e1ca87b0a02e0a6fd5ac0423"
    sha256 cellar: :any, arm64_sequoia:     "f1c5ef54bd6dd1f0e8b0aaab02b0aa2eb7595fd2e8c0c5a8663420fb2dd6a9f4"
    sha256 cellar: :any, arm64_linux:       "9526fa22207e87c93999a3edb687c335929b0c5ff1c74b9d0812aea43f24ae11"
    sha256 cellar: :any, x86_64_linux:      "ad180b002f535be0fdc631db0f738442e250b6286b903f0edb4889fc6fdb2116"
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
