class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.13.1.tar.bz2"
  sha256 "df2c50503295f325e7c8d7b783aca8ba4773919cde984193850cf9e361dfd28c"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c1bdb695d5c0d734290088aa092a22f4ecf7174a293e4da4ccbd4c19a014f2a"
    sha256 cellar: :any,                 arm64_sonoma:  "ae1a6948d30b7be5f3909f4d6752662ff8745b2a25ec704c1b96426fc364c38a"
    sha256 cellar: :any,                 arm64_ventura: "b56905e01d61fb9cd149eca33c990c35d4a6f5106ef0e9d34fb731f18cc645b6"
    sha256 cellar: :any,                 sonoma:        "dbfd96af015a537d72465c3c46f70d72c5a77cfe9a4ddcfb96fecef3eab960d5"
    sha256 cellar: :any,                 ventura:       "feb9f28d5e90f3e164d58fff553591106e89fe4fa74371e1cfef4752d116f687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "212d46a130ce7af2363009ff0f89e2ce1860a9d21976f0aa46450f2ea3041329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20cd2195994f77e923c36842647afb444da7f37bce779197e10a2bdd2983db7a"
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
