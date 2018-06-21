class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.3/libical-3.0.3.tar.gz"
  sha256 "5b91eb8ad2d2dcada39d2f81d5e3ac15895823611dc7df91df39a35586f39241"
  revision 2

  bottle do
    sha256 "912b5de25b8b87ec64a28c2226c9acf0f89ce5cf336b7a4c0d60b7a64a4b086b" => :high_sierra
    sha256 "af9ac02655f33d97a9c818e6f124409d5e6b79583bb15de97a08e62cd28378c5" => :sierra
    sha256 "deb49e4bf9b66e2a28dc7538801c119b361c64cb527e36bbf7cb7c74fc54fc9f" => :el_capitan
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
