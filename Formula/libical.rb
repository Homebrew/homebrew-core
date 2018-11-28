class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.4/libical-3.0.4.tar.gz"
  sha256 "72b216e10233c3f60cb06062facf41f3b0f70615e5a60b47f9853341a0d5d145"
  revision 1

  bottle do
    sha256 "205026b787a55ff63c648c35f9d1de0236fc699ee7498bc2b09ab3899431b170" => :mojave
    sha256 "edc96595f6d0d8ca5c7c42b6ed8eda3435d5f3a6f4c6673890ecc1ee79243529" => :high_sierra
    sha256 "05033e4e3adb9b269a69061cf8b3b62d21095f4bd7a724a34a6966b7c814f9a9" => :sierra
    sha256 "d313668570afe5b0eb40c5f7f1037d181596b1d172975e5ceaa69cbeaced87b2" => :el_capitan
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
