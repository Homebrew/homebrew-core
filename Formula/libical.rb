class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.1/libical-3.0.1.tar.gz"
  sha256 "7f32a889df542592a357a73ff5f3bd7b5058450c1a3fb272b1c9a69e32d9ed10"

  bottle do
    sha256 "3474b7ac728488ac0ea463ff327d9068a7414ae01dbdcef43db7075541d9ac19" => :high_sierra
    sha256 "f1a8b9de2fd437ae29828fa2f5edb1da77d4cf1b047d60412cbdef14b4362b6b" => :sierra
    sha256 "f03bb074f6c3ff1cd42726eb779f8c05c91f5dfb5118d06317f31159d886ee8e" => :el_capitan
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
