class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.4/libical-3.0.4.tar.gz"
  sha256 "72b216e10233c3f60cb06062facf41f3b0f70615e5a60b47f9853341a0d5d145"
  revision 1

  bottle do
    sha256 "42d6e8ca8a0b5b4a04a1444b8370a8bc5663cccd69ca5c15b91005148c9011da" => :mojave
    sha256 "512f28a610777ff78aacf9ab8e6e2b9cd45eaa2dc3eeb696139bbe7c5fc62bba" => :high_sierra
    sha256 "d1e06a7e4c3af68b3188c047cc915e6cbef75c74373bfa811da686a5d18f742b" => :sierra
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
