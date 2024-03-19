class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.17/libical-3.0.17.tar.gz"
  sha256 "bcda9a6db6870240328752854d1ea475af9bbc6356e6771018200e475e5f781b"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1af763d3dd856385b6f94ba209b38939ac1daa12799bd9d5d2e10a81640f520c"
    sha256 cellar: :any,                 arm64_ventura:  "4867306e4adc3a8f794b3b8f1bbd93e251fba98c131639a900929c90730f7fd5"
    sha256 cellar: :any,                 arm64_monterey: "f05e4ed4ae8cdea1022c8c027bcc1b7b1ce04d376bc7a3c5e2fa327f8a9931bc"
    sha256 cellar: :any,                 sonoma:         "b80531fedba0ff6122e8f39a9a8ebf65820e1384ed71fd3542fb7dad4f528ad8"
    sha256 cellar: :any,                 ventura:        "75078221ada785e1e3e934f757da58eca2a18be318a1037bf3c832551c081ff6"
    sha256 cellar: :any,                 monterey:       "4964d30deefc51d857162ab1e940436246319b68c8dc683f08bc02aae3627935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "618f5ea1d2fbcd833df7f88ce28bc191fc8d9f8c5a0500b7441d60f4ccf8d5ca"
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
