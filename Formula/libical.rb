class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.3/libical-3.0.3.tar.gz"
  sha256 "5b91eb8ad2d2dcada39d2f81d5e3ac15895823611dc7df91df39a35586f39241"
  revision 2

  bottle do
    sha256 "791810c363525ac618fc57e84b8c5fa71a45991514a26ba36162d771900b9cd7" => :high_sierra
    sha256 "aa1f3415f89ae0798b8207b3e805c1dcb5d8e55fea67e407efadf434b4f1cf8d" => :sierra
    sha256 "dbedcf59167b38d1be9625f0d7da3ff11882e551416bf6c3bcf0b347416eaa87" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c"

  def install
    system "cmake", ".", "-DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND",
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
