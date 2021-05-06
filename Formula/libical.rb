class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.10/libical-3.0.10.tar.gz"
  sha256 "f933b3e6cf9d56a35bb5625e8e4a9c3a50239a85aea05ed842932c1a1dc336b4"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 1

  bottle do
    sha256 arm64_big_sur: "a7658e9ae8a6404685ce931b5a19eb950817915b910680778db9497245c3214d"
    sha256 big_sur:       "d4719732f95e73c1c85cfcfecf14249036af09b15444f22903be74fd84bfa9d0"
    sha256 catalina:      "b9ea72b109cc455f12925e0a3c5089d00741468c7d5281c53bdcd535a40a31e2"
    sha256 mojave:        "f4a628cd0a30a0eb8f961a0012f2651346b8c45d4e36ebf9b741ef4a98d421f8"
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
