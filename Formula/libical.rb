class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.9/libical-3.0.9.tar.gz"
  sha256 "bd26d98b7fcb2eb0cd5461747bbb02024ebe38e293ca53a7dfdcb2505265a728"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    cellar :any
    sha256 "63bf149d253ce0058dc0c8d482498bcdc2f98a1f5fbbcbb5e994ca5902d2585a" => :big_sur
    sha256 "aee72172114e605f00d453d7a2f5e7be3b813fcc56d05463c97de76f579db5f4" => :catalina
    sha256 "93bd93bbad50f91aaa215ba2f764046fef919790a4ff227328a309b2ad2490d2" => :mojave
    sha256 "3ff8dae7c504718bffd8fb8ce066c3b5c777d12250bdc87ff3fbb7f230284d1b" => :high_sierra
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
