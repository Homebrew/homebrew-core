class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.8/libical-3.0.8.tar.gz"
  sha256 "09fecacaf75ba5a242159e3a9758a5446b5ce4d0ab684f98a7040864e1d1286f"

  bottle do
    cellar :any
    sha256 "0f588122505c74f1201a423c5880eb62b5626de92ac0d0641316ae3e365c1737" => :catalina
    sha256 "ff66a226b939d9ad9b2329b46363b55e394aa0d3069c1341b89e5136db07d338" => :mojave
    sha256 "d62b32231c68fa135096236a415303073001c281ae94574c44801b124711b4de" => :high_sierra
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
