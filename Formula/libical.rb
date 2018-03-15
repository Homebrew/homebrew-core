class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.3/libical-3.0.3.tar.gz"
  sha256 "5b91eb8ad2d2dcada39d2f81d5e3ac15895823611dc7df91df39a35586f39241"

  bottle do
    sha256 "1db80d26f22a9c81e633d263fa2aa4a0aa09b47553972af74c05f5fa0fd55065" => :high_sierra
    sha256 "c57e73fee5d0482291095acda0783f16c4e4f8ee31d82b4b41ace2072d88987c" => :sierra
    sha256 "205ffa25d970c4eec239237553e3ff768483759dec2bc42d7a6c5933b1bfd726" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "cmake", ".", "-DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND",
                         "-DICU_LIBRARY=ICU_LIBRARY-NOTFOUND",
                         "-DSHARED_ONLY=ON",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
