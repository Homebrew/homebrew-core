class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.0/libical-3.0.0.tar.gz"
  sha256 "ac2b3d8001d03818bfddec229b45c68eef84301714c036056395b9b0365a2b0d"

  bottle do
    sha256 "8228ffa72b7f26c8640eb25dd5d6cd08f84d9736304ebfacb2f5a22a029cc338" => :high_sierra
    sha256 "4b8b3165661fca6ae137559f3b9d0436bee37284ce84c75e9e81677512bacd43" => :sierra
    sha256 "80cd45eebc20492169a98e26c2ac384d9e7d42c60c97dfb31cf15fa3c978ea27" => :el_capitan
    sha256 "f4cbcfb04208a01f1589f119e785c656b74713d033949e8a6a367a759ea142eb" => :yosemite
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
