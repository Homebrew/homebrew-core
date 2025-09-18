class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.14.0.tar.bz2"
  sha256 "fe85286b1977121894794b36a7464d05049361bedabf972e70d8f9bf1e3ce928"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "241ed0bffe8d655b58ce9b4109e07ba5c71f943ce8f4e9c8f48dd88645ceaa8f"
    sha256 cellar: :any,                 arm64_sequoia: "cd547521b23dcbe44aa776ef0e581da5676755a2d478f1d656730e68a7ce28d7"
    sha256 cellar: :any,                 arm64_sonoma:  "e55ef72af91aabb8cb9c984921e4f4cb5043aaa51f6dfe6d044497c4fb62a5d9"
    sha256 cellar: :any,                 arm64_ventura: "c3e1b0bf8588c2e814ed80d5a187007e597a2b7a8a8f92687436e4ff6a016f57"
    sha256 cellar: :any,                 sonoma:        "b709e3efce2193115d299a1c8fa8f8028b48343270d7e9d15b6d9f38b07df270"
    sha256 cellar: :any,                 ventura:       "41a5443c009d31472483d53fd4d0a6673355b6ed7342b55a82120ee8f8349291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b1c80b2a4ff62eb2c48e09702f7c71da140c8ca1476011ae3cbb8a4a0c356eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b5ebc471822878a1a30014a1035a5e17b79cfe2a7c713734fe168b4acfdd31"
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
