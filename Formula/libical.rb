class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.9/libical-3.0.9.tar.gz"
  sha256 "bd26d98b7fcb2eb0cd5461747bbb02024ebe38e293ca53a7dfdcb2505265a728"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 2

  bottle do
    sha256 arm64_big_sur: "92dff71359989b5e1d9b393ad32577a1cb7462ce96654292d5a4694a93230010"
    sha256 big_sur:       "76add0e5fce6a528dc2ab84b226524f587e663ad349dfad726b2d4915e8f1c91"
    sha256 catalina:      "53c30edf307bf09de5f04d83d4772a27073aae375e4ffb3157f6e4f20e8af9b0"
    sha256 mojave:        "dbb77478aea20be00b83f170849d064b0ee870a9481ad2abf93c56d16c680dc7"
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
                         "-DCMAKE_INSTALL_RPATH=#{lib}",
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
