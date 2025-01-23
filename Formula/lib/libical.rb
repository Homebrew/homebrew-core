class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.19/libical-3.0.19.tar.gz"
  sha256 "6a1e7f0f50a399cbad826bcc286ce10d7151f3df7cc103f641de15160523c73f"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a6dae4a92f065ebc7e06843b2983b42133df6ce2ed2e6168a9b1b970c5fdd105"
    sha256 cellar: :any,                 arm64_sonoma:  "d207372138129605cd50e713d8167f58b71f8c19d6e77ba7898673c3fe821070"
    sha256 cellar: :any,                 arm64_ventura: "2d89c11b85761c3cf357f27b7e3b6712faefbabba77368ab12946ca4d97951c2"
    sha256 cellar: :any,                 sonoma:        "ee002ff8085136d6603c358c3b6256c5d6c4dc2609d6f9d2afaa86e9e5d8ad75"
    sha256 cellar: :any,                 ventura:       "efd1e91cb898f2c97697c3cd5611b75826b10f5028f7cdb0705645017d92f75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b97de9662735ed49c86b83c73eefaa27e3dd3e0f699d337f605f8d5aa0121fe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "icu4c@76"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "berkeley-db@5"
  end

  def install
    args = %W[
      -DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND
      -DENABLE_GTK_DOC=OFF
      -DSHARED_ONLY=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
