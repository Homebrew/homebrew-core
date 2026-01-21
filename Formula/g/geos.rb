class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.14.1.tar.bz2"
  sha256 "3c20919cda9a505db07b5216baa980bacdaa0702da715b43f176fb07eff7e716"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14dd1aa5cc405dfeae08d1d91447a88324b7695161ae5dab0e8857f7ca483f48"
    sha256 cellar: :any,                 arm64_sequoia: "d505907854d0d1bf2e7b5759a3e1af38cea682c5ed083a2201cd5e6bc472f4ef"
    sha256 cellar: :any,                 arm64_sonoma:  "b27c740de141794db4f06ef3f1c07c0d91749eaf101fa68af35e4076eb01fee8"
    sha256 cellar: :any,                 sonoma:        "931850437a3095cfc4ea651c31ec15c26d3abc5d595690a1dc5550db88e73fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72195e62b8abb9efc31d422cfddf24caf0b99d3a394e3ece252114e14b0dc8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b8dd1db22e06a341963a5c2c0e6dc4d83153ac7d80afc117fbbaa548569d17"
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
    assert_match "POLYGON ((10 10, 10 5, 5 5, 5 10, 10 10))", shell_output("./a.out")
  end
end
