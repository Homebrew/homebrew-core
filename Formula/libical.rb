class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.15/libical-3.0.15.tar.gz"
  sha256 "019085ba99936f25546d86cb3e34852e5fe2b5a7d5f1cb4423a0cc42e399f629"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fd4d453a3cef1834346adea58fa384587c466649dfc9ad120c31dcea6d185199"
    sha256 cellar: :any,                 arm64_big_sur:  "4a869794441e4433f054246f57a8e6bb2951f5425c21a1aa93164fd5b7417ed2"
    sha256 cellar: :any,                 monterey:       "bd794dbb4e37466516dcbe502e715b6fff10201b2e439aed5b3a17988eb76df8"
    sha256 cellar: :any,                 big_sur:        "ace3392af1b83116561a2e4caee6c808a96e6017ab2b5dccfc34952d81ba3dd8"
    sha256 cellar: :any,                 catalina:       "9903de75b25ee53b2c0881b8e812733a85e32022b3c17a53146415a200610ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0459f752a32ae67a4e4f29d69d6085d7ae1b5bebed208b41adf96710e99cad2"
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
