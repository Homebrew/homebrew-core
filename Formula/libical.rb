class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.9/libical-3.0.9.tar.gz"
  sha256 "bd26d98b7fcb2eb0cd5461747bbb02024ebe38e293ca53a7dfdcb2505265a728"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 1

  bottle do
    sha256 arm64_big_sur: "4444c686c12f4ccb5a2b1bba379b8b3e10b0c682e74664f003eddd188666d706"
    sha256 big_sur:       "50b73e2b2e9de25823e1c8aaad76e16aa6d40d0926de9ed5b41165fccda96cc7"
    sha256 catalina:      "56d8b3f3052c096d59cd1aae698c577e701958d358f4a60497e82d807995580c"
    sha256 mojave:        "4a33de39cdae5faf12efb0767b48218b002a7f674fa6eaadbfea1288a8c1c5cb"
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
