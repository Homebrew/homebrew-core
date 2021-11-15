class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.11/libical-3.0.11.tar.gz"
  sha256 "1e6c5e10c5a48f7a40c68958055f0e2759d9ab3563aca17273fe35a5df7dbbf1"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a808c0aaeb3d08c784dcb5549f6e3b3c41e558f2a98731e072eb9728ccca127b"
    sha256 cellar: :any,                 arm64_big_sur:  "96f08215d53d105d1828320cb7992482867be06628892c1d9c38f6513008f4ba"
    sha256 cellar: :any,                 monterey:       "3c2d986b51e7c14b32d7fbb482e54d09338b059b994c05bbef534c2bdddd3324"
    sha256 cellar: :any,                 big_sur:        "f632f09ff759cb8ee10b877bb1e797e577a806d736fe0faeb39400e29e14eaae"
    sha256 cellar: :any,                 catalina:       "92914c8ae64d8aa71de95e9e9172696389d9978593aae8053dc0ccf2194713a6"
    sha256 cellar: :any,                 mojave:         "bc6181c6e46bfc8d6ee3683262f52b8948b684d66e060a468cb5d939a85ca950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "975d3e9c770f30571fe8cce133253cf93f4436127abda56fb63b6419927dc6c1"
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
