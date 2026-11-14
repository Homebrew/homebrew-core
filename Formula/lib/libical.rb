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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2629f6d51bb6bd7c24c99f7056f0fc4d856e504dc78fa755c9fd8e5f9f5573b5"
    sha256 cellar: :any, arm64_tahoe:       "fe51d71d63b2c370c86e21c3f5b38cab6bee34cd5d7b7941205a655edcbfad36"
    sha256 cellar: :any, arm64_sequoia:     "1da40a7df5157e01229b6cf3ecdd9cc90571a059826777ba3fb76d3fa2c4b1e2"
    sha256 cellar: :any, arm64_linux:       "2f092214ed70c42bd6d17dd826d478809097578a6dee22755c14f0d03f752a71"
    sha256 cellar: :any, x86_64_linux:      "93f0223faf90bcf0ab98537c186eca6c3c7a5584c2714144cf2a056a030e50c5"
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
