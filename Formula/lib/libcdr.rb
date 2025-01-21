class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.8.tar.xz"
  sha256 "ced677c8300b29c91d3004bb1dddf0b99761bf5544991c26c2ee8f427e87193c"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb6eff3f4627fcc102cb45b8da2f35f82e5049d6a0875c84334484388ede2025"
    sha256 cellar: :any,                 arm64_sonoma:  "1798c673e5c3c0c793cf9e3d5454bda00724244e189535c68ef476303d2a0405"
    sha256 cellar: :any,                 arm64_ventura: "2ef42ae303f70cc8294e5082588f5b3c63dcffa70acba167d63b65e3b1d92798"
    sha256 cellar: :any,                 sonoma:        "889c0540fcae08302afdd508ecf8287c41b7b8cac892cd5b834383dce1310a4c"
    sha256 cellar: :any,                 ventura:       "9bb8d4bc98a361e1eee954a04f8ad930dcfc3958cc80ecf5c493cfdf83d74448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4dd30a7edf347fdb569e2d1e9a4a0f053dbce86d23f2096b8f26f542768517d"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@76"
  depends_on "librevenge"
  depends_on "little-cms2"

  uses_from_macos "zlib"

  def install
    # icu4c 75+ needs C++17 and icu4c 76+ needs icu-uc
    # TODO: Remove after https://gerrit.libreoffice.org/c/libcdr/+/175709/1
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    ENV["ICU_LIBS"] = "-L#{icu4c.opt_lib} -licui18n -licuuc"
    ENV.append "CXXFLAGS", "-std=gnu++17"

    system "./configure", "--disable-silent-rules",
                          "--disable-tests",
                          "--disable-werror",
                          "--without-docs",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                                "-I#{Formula["librevenge"].include}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-L#{lib}", "-lcdr-0.1"
    system "./test"
  end
end
