class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.2.tar.xz"
  sha256 "0e422d1564a6dbf22a9af598535425271e583514c0f7ba7d9091676420de34ac"
  license "MPL-2.0"
  revision 5

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libfreehand[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "eaaf703b1fd053162dab3babe94df1a9892a6cf6ec36bc633803d8dba4d9878b"
    sha256 cellar: :any,                 arm64_sequoia:  "9eeb0bbec76d98ba004514dad9c9dc345a66fde115e25cada3fc837efcb764c7"
    sha256 cellar: :any,                 arm64_sonoma:   "10f6c8c203685f706e8290abc6a8c6833203142083d267f2ef271d34e998497b"
    sha256 cellar: :any,                 arm64_ventura:  "53c1bcbcf740c42c5900949f2859734be9f3aa4adfa28f42a521d6c1618a8797"
    sha256 cellar: :any,                 arm64_monterey: "7960ce23fc10f7c545aa6ff36704340626b5652cdf514e2cc30abfd06923f158"
    sha256 cellar: :any,                 arm64_big_sur:  "1cd27b1d82fe6261a9def131e7a09143b35fe7547cbf539b720fc9d8bdc257b6"
    sha256 cellar: :any,                 sonoma:         "caca6cf46c41a2fb5e086122bf045c85ab46a93edaa793dcbe3ff74f67db637d"
    sha256 cellar: :any,                 ventura:        "eeccebb0f1538b6a31480588def2399898dc5b1a46ab208de2ffe9cdeb693fa3"
    sha256 cellar: :any,                 monterey:       "52bf47cdb858c77f4745bae826181ff0790fa3bad79e8997fb6b4a5702fa218a"
    sha256 cellar: :any,                 big_sur:        "736e40282e91275e85e6586f9601bebf05a7111e484776a3a1cf8df1e266b329"
    sha256 cellar: :any,                 catalina:       "337aeb3f1454487fc132f9d67e3662dc6c3f0ba40a38a9a9c58d9f0b9bfc1955"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "36565f2d8aeeeab824700436476cb784c742a76d4b412397de179a6a43828880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "231727d040b34c931b60d06ad1f0fa86d08dbde4d00736e6233645d635393a7f"
  end

  depends_on "boost" => :build
  depends_on "icu4c@78" => :build
  depends_on "pkgconf" => :build
  depends_on "librevenge"
  depends_on "little-cms2"

  uses_from_macos "gperf" => :build
  uses_from_macos "zlib"

  # remove with version >=0.1.3
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libfreehand/0.1.2.patch"
    sha256 "abfa28461b313ccf3c59ce35d0a89d0d76c60dd2a14028b8fea66e411983160e"
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
