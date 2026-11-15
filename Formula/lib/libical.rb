class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v4.0.8/libical-4.0.8.tar.gz"
  sha256 "cd486bb3ece8256c34f1a236e174992c66ecb46b592a65f3f55d24d49eb66a5d"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eea0a690ad9b6110d253d03c345aedcbdf8a0ec384f3491b078aae6751ab5f15"
    sha256 cellar: :any, arm64_tahoe:       "5cdba727ac85333a27a54adb5e883354f947c9bfb5adee3ce605f3453943e244"
    sha256 cellar: :any, arm64_sequoia:     "298899bc4715eff088c5d0add4ab5c0d7911a96a168a8fca3a5a747b77c9d98b"
    sha256 cellar: :any, arm64_linux:       "41a5daf50d96f0e63be9ebb44e255c4469bc4c055cd69681b7480c5341423a8e"
    sha256 cellar: :any, x86_64_linux:      "8715111d7523e641a92699819602c31c50d68322ed5502fa6b7c3d9574752751"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "icu4c@79"

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
