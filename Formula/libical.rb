class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.14/libical-3.0.14.tar.gz"
  sha256 "4284b780356f1dc6a01f16083e7b836e63d3815e27ed0eaaad684712357ccc8f"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a0dcdc93cd6a7c28c73da05c462e4b3a1ff939a79a8e63773a4c3d0cedf4f3d5"
    sha256 cellar: :any,                 arm64_big_sur:  "c842d3fd0bf2289290594347a2f033d430d46bb6dd7d2f14032d572e9fb50ef7"
    sha256 cellar: :any,                 monterey:       "e0c35326c070cea82baf73a4de5e6c345a8f21caf3856b218ec848d2e26e40ca"
    sha256 cellar: :any,                 big_sur:        "254b698a3e6585c454fe3016163ebb4a2c79af2f8dc52c7021f060e11e5fc9a6"
    sha256 cellar: :any,                 catalina:       "5291e0837b718b5c4492e1bb341cce0b41a5b5103e1fc9435133b9a3a56984b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb299a37b4ef679be59e4c384f0704dba419394617627d5c00aa877282a593b4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c"

  uses_from_macos "libxml2"

  def install
    system "cmake", ".", "-DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND",
                         "-DENABLE_GTK_DOC=OFF",
                         "-DSHARED_ONLY=ON",
                         "-DCMAKE_INSTALL_RPATH=#{rpath}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
