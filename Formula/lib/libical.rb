class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v4.0.0/libical-4.0.0.tar.gz"
  sha256 "caa74119c5a83d19e7466f20344ea6ffe4b779198ee33f46d5fab9d574dac207"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f2fbf1373acc6b2c802eb317f51e96e5f0fbcc52fed2b41cf56f670bf1d3b62"
    sha256 cellar: :any,                 arm64_sequoia: "b6d56ca548e974595fc0e0bbc4341a232aa6ce40f497c285dd6b1a853aece64f"
    sha256 cellar: :any,                 arm64_sonoma:  "3e32dea68213a63da789a8d0e2c3d0b0ff80ac9f002ae88d8769e752b6363c13"
    sha256 cellar: :any,                 sonoma:        "204d5434b3145264af4742b4fd5d23b570379ac155c9af8ecbabb8c0e76bded6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d4a0166dabbf5931fd6802733c620165110b5726d49120e917d89fc006694e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9811f27e25db2f8762ae7b3522e41500f529fd5cd47b590ccd5449fc69102a64"
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
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
