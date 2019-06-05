class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.5/libical-3.0.5.tar.gz"
  sha256 "7ad550c8c49c9b9983658e3ab3e68b1eee2439ec17b169a6b1e6ecb5274e78e6"

  bottle do
    cellar :any
    sha256 "a74d816cfb5e859d24f6ace15663350b8dda910665b30a9c8c36a21a69e807f9" => :mojave
    sha256 "8aaa85681f953950443c403d4330346a894c69dc8be8be9fa8c428eed1d15173" => :high_sierra
    sha256 "4a255f38fa7b8266fa1789004ea8c3855f7f6edd370cd23526cb43acb95ee9ac" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c"

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
