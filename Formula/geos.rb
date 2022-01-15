class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.10.2.tar.bz2"
  sha256 "50bbc599ac386b4c2b3962dcc411f0040a61f204aaef4eba7225ecdd0cf45715"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d8b8b13dfa2f7fc1b502d25c6a9b8dd3da522d9ab1856ee8195eaa28662a6473"
    sha256 cellar: :any,                 arm64_big_sur:  "6ca259c932202769dcbe33bb8c47192910c61937a0faf8fbd09f80caa684b47d"
    sha256 cellar: :any,                 monterey:       "4b258a8aba82f212ac164671f503d0d8af9d4e1d321b52b53e8a6d6f5de5fce0"
    sha256 cellar: :any,                 big_sur:        "818caef2d6ff611066afbf8e9547b1c63719de7048d7c0cb7aa096f163ac70b9"
    sha256 cellar: :any,                 catalina:       "a3f6adc759b2da03b9033124d321af08d0bc8915534d258e519e069d6cb94a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d881fb26cc92fa92a1522cc3497e3caa0d348a8840b4df2251cb11adb07d9cda"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install Dir["static/lib/*.a"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdarg.h>
      #include <geos_c.h>
      static void geos_message_handler(const char* fmt, ...) {
          va_list ap;
          va_start(ap, fmt);
          vprintf (fmt, ap);
          va_end(ap);
      }
      int main() {
          initGEOS(geos_message_handler, geos_message_handler);
          const char* wkt_a = "POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))";
          const char* wkt_b = "POLYGON((5 5, 15 5, 15 15, 5 15, 5 5))";
          GEOSWKTReader* reader = GEOSWKTReader_create();
          GEOSGeometry* geom_a = GEOSWKTReader_read(reader, wkt_a);
          GEOSGeometry* geom_b = GEOSWKTReader_read(reader, wkt_b);
          GEOSGeometry* inter = GEOSIntersection(geom_a, geom_b);
          GEOSWKTWriter* writer = GEOSWKTWriter_create();
          GEOSWKTWriter_setTrim(writer, 1);
          char* wkt_inter = GEOSWKTWriter_write(writer, inter);
          printf("Intersection(A, B): %s\\n", wkt_inter);
          return 0;
      }
    EOS
    cflags = shell_output("#{bin}/geos-config --cflags").split
    libs = shell_output("#{bin}/geos-config --clibs").split
    system ENV.cc, *cflags, "test.c", *libs
    assert_match "POLYGON ((10 10, 10 5, 5 5, 5 10, 10 10))", shell_output("./a.out")
  end
end
