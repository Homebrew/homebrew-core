class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.3/libical-3.0.3.tar.gz"
  sha256 "5b91eb8ad2d2dcada39d2f81d5e3ac15895823611dc7df91df39a35586f39241"

  bottle do
    sha256 "d3d1e7d0098735a2ccabad0a1d78a0f822ab462ef163b788c0f232a08213bdea" => :high_sierra
    sha256 "3c245176c480cea929038591597a512c290b589209c5eaabcc7a687705980379" => :sierra
    sha256 "1f517c80f40a1ef630f2c9312c3b8b7a28e5772d251211e27bbd3ef2cc272219" => :el_capitan
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
