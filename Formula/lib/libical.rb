class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v4.0.7/libical-4.0.7.tar.gz"
  sha256 "47c05bc96e41416578cf1803bb2ba3f8d292cb17d5ac2fca539dee922bae8a94"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f857f38441b912f1155eea2cff2d96b64a52e0ce07d96e02aabab45d903fd66f"
    sha256 cellar: :any, arm64_tahoe:       "9c6879f94f004d648c00f4013dee56afc7efd3775c3ebef8bb90f4998ad7dda0"
    sha256 cellar: :any, arm64_sequoia:     "d5411e173a5470fb9f42645cae053fba8bc8ff027d03c8fa87c28f4091a865d8"
    sha256 cellar: :any, arm64_linux:       "1ea09e18f2d82cb337fea9d23b45a8263e064dd85b2fdfee25c7b5f2020ae625"
    sha256 cellar: :any, x86_64_linux:      "4093d940dccab0574c7a6080631ccff0892b8a50831d4fd55dae9b745c137869"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "icu4c@78"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_DISABLE_FIND_PACKAGE_BerkeleyDB=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIBICAL_GLIB_BUILD_DOCS=OFF
      -DLIBICAL_JAVA_BINDINGS=OFF
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
                   "-I#{formula_opt_include("glib")}/glib-2.0",
                   "-I#{formula_opt_lib("glib")}/glib-2.0/include"
    system "./test"
  end
end
