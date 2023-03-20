class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.11.2.tar.bz2"
  sha256 "b1f077669481c5a3e62affc49e96eb06f281987a5d36fdab225217e5b825e4cc"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b81d71db36cebb8fed14b3c53a3978d39481d4f2d1ec2717594c39adc5c17c5"
    sha256 cellar: :any,                 arm64_monterey: "2038022f7a0345ef6c89a3b21683f7eb27795d78d1344a35e0bd364a4b9ab370"
    sha256 cellar: :any,                 arm64_big_sur:  "5e31db4c242aa1bb8ffe0031d9c4620ecca0a9d119b92aced7bd89c46182456c"
    sha256 cellar: :any,                 ventura:        "682db574fdf6028c93bc0cc9e444034c316afccf7af1951ccd2eecc31794f0f4"
    sha256 cellar: :any,                 monterey:       "3bc44df6394ffca07b11b5df7b6f1208210859959c2300e884d20c352f31dd20"
    sha256 cellar: :any,                 big_sur:        "a643263cd1163c2119e54367108b59797ec1cacc05d482c115ea208c951751ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdcbe64c368ea4f72fc16c390bba243b46854002293917c071ea2d33f40e6511"
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
