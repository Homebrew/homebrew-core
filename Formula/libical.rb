class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/archive/v3.0.7.tar.gz"
  sha256 "546115fe53dc8800e79478211efa5c2cfe7cae8e34cff54fbc14b42cd98e4fe5"

  bottle do
    cellar :any
    sha256 "07655cf921ae272e80acde10ad0d0669ed445954ead4804be29edaaa11a04706" => :catalina
    sha256 "2e2bc2c5ba396ca27aed526c8463ef3078cb5d238b1a0165de977468dd2d6467" => :mojave
    sha256 "7a3afd92474988902635c2c69c86c46e4273c000e6ac34f62b74a6c77a576332" => :high_sierra
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
