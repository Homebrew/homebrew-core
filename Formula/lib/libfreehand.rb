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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b70e47c7931caefe4bc6b042a589ace7ab5030effc050d9497cb18402aea3283"
    sha256 cellar: :any,                 arm64_sequoia: "694fa1b16a31cc867224d2816c9cb64729d424c08cd62e60d0d297afaa0ad1c8"
    sha256 cellar: :any,                 arm64_sonoma:  "33ae6b9ac25647ca21bd483f7621bc89b40bc56ceecbe1016b62ba9efff537ff"
    sha256 cellar: :any,                 sonoma:        "fa66877154b2d6ce16f342ac50f6426a075700f13a6373f439df66803d7c00a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "952ae31e98ef2f960942b8a53c8655b391992bc4f1427e3068f64286308c5c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d35269b7696910c40ca4ef8d69418ed4eb8983d5c0e0079a0e36ead6cfd5407f"
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
