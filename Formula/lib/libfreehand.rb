class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.3.tar.xz"
  sha256 "a431d78767e5aa27ade7c6d1b7a11a9f1848cb4b9260bf0a6a44689553ecccfe"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libfreehand[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d33bddefbe09049bfefff702e617aa5072b03ab2602af75c3fdc1b7ce3cd0ead"
    sha256 cellar: :any,                 arm64_sequoia: "4c601bd55e81fef558bf0c681b953d8467250f897d67e7ba764aeeff3b5f24c2"
    sha256 cellar: :any,                 arm64_sonoma:  "31e4a1c33344398e8ea91f4f324a21589e565f8e3921db4abfafa5a455cc8b98"
    sha256 cellar: :any,                 sonoma:        "b6249e044b194cd34175495d5c42f8e6ac70a0d2f61e422bffdfbe62b3f4110e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78013df6365bdb51b64b118de7b04dadee3207698dbffe86ee96063b82e1ca63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f7a7c203127d2ce3f773d8fbb2b85fa37923215b303a112f7860eae687da4eb"
  end

  depends_on "boost" => :build
  depends_on "icu4c@78" => :build
  depends_on "pkgconf" => :build
  depends_on "librevenge"
  depends_on "little-cms2"

  uses_from_macos "gperf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--without-docs",
                          "--disable-static",
                          "--disable-werror",
                          "--disable-tests",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libfreehand/libfreehand.h>
      int main() {
        libfreehand::FreeHandDocument::isSupported(0);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libfreehand-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-lfreehand-0.1"
    system "./test"
  end
end
