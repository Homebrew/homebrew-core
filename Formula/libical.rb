class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.10/libical-3.0.10.tar.gz"
  sha256 "f933b3e6cf9d56a35bb5625e8e4a9c3a50239a85aea05ed842932c1a1dc336b4"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 1

  bottle do
    sha256 arm64_big_sur: "78820f4354ff775e64e9c513b55f5e5a40db58705642bcf59a1e55ae822a83ef"
    sha256 big_sur:       "aeb2152eb974ac69926bbcb5b1b8f2180cf144ebb840a59fcb835dc1a2a749d5"
    sha256 catalina:      "b024a7bd0873db2015f36a5ea332cb4edf3fe31b0780b622f024cda0347a7560"
    sha256 mojave:        "e417dc1981f7baaaa0acf469e65fff9d14843efe64d7b62537b26e3f484724d2"
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
