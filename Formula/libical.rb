class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.1/libical-3.0.1.tar.gz"
  sha256 "7f32a889df542592a357a73ff5f3bd7b5058450c1a3fb272b1c9a69e32d9ed10"

  bottle do
    sha256 "e00639c8e22c1e65492d11fc1486f38f8c1e898cbca7d704777040e088d3192b" => :high_sierra
    sha256 "640045615ee37609804b4f19479e813d7cbcbdbcc5ba92821c11507ed38768b7" => :sierra
    sha256 "8188a81db33ac7f104254a24b5c94480445d50b09a71c11f14bf5d06086b7a0e" => :el_capitan
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
