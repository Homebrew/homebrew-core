class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.15.0.tar.bz2"
  sha256 "d5e5192a686d065eaed082de14dd26244c5c8e02bff16b2c6cce3265f648e00e"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8f09ce56a97b7714e978c079793a9595292542b0676c742f02bff008eafcb7f6"
    sha256 cellar: :any, arm64_tahoe:       "ee2885091289736655eccd714125c4202537a81b91facf3033f9f6387b66a441"
    sha256 cellar: :any, arm64_sequoia:     "90785c1140619743ebf629f93da255b7b490f44b4a2e143bd1b6cd9b4d2d64f9"
    sha256 cellar: :any, arm64_sonoma:      "8313b72df2431403753009907bbef383805dce12087b0852d3c04489ac686647"
    sha256 cellar: :any, arm64_linux:       "2801e57ff42aa35f5e52e6f9f3dad19633f7125a0da010e0886c22bbfc53bfb6"
    sha256 cellar: :any, x86_64_linux:      "ae8443b99cf965e4828c172fab22be7a7fe3424e6d8f6b3c7c99fe960f7e7664"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "static"
    lib.install Dir["static/lib/*.a"]
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    cflags = shell_output("#{bin}/geos-config --cflags").split
    libs = shell_output("#{bin}/geos-config --clibs").split
    system ENV.cc, *cflags, "test.c", *libs
    output = shell_output("./a.out")
    assert_match(/POLYGON/, output)
    assert_match(/10\s+10/, output)
    assert_match(/5\s+5/, output)
  end
end
