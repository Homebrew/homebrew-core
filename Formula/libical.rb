class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.4/libical-3.0.4.tar.gz"
  sha256 "72b216e10233c3f60cb06062facf41f3b0f70615e5a60b47f9853341a0d5d145"
  revision 2

  bottle do
    cellar :any
    sha256 "582d610a9cdff9f9e0ca7cf4462b9a455c38a5f1211e9fae155802cfa0b85d04" => :mojave
    sha256 "48159553d4b3e7119ad007d4cf35f2cfb10da5c29b188a9b6e847532f67af5c3" => :high_sierra
    sha256 "d29871503340b03b7f70e45c33c19f599287297e69cb1c6369f5c2f5bfd92c9c" => :sierra
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
