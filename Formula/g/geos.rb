class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.12.0.tar.bz2"
  sha256 "d96db96011259178a35555a0f6d6e75a739e52a495a6b2aa5efb3d75390fbc39"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bf4c039446e6b3f5ba706af44f60204b9c70073a10791ca2855eae3a7d499604"
    sha256 cellar: :any,                 arm64_ventura:  "3ba823368eb77741222d965f954b635e779b96eb1bf646f1ec6d5c688714f4c3"
    sha256 cellar: :any,                 arm64_monterey: "260454c4c2ec6ce753eed67c930e0bffb4209e5120c18b11de8526217bc01298"
    sha256 cellar: :any,                 arm64_big_sur:  "6fde6c00108bb83d3fe7c463a8b6463f711533d243be257ae672c5f6c8b5d821"
    sha256 cellar: :any,                 sonoma:         "49abf2dd2a65958ffdfbfcf9d81761002faa7cc8c1e5c56bc228844542b1ca08"
    sha256 cellar: :any,                 ventura:        "73ddca31e205dd9f87a713c702ff18a312522b6ffaa4983ac2fb1187111682f3"
    sha256 cellar: :any,                 monterey:       "1a14c6f67d8299f354a35e3dcf3bdb60dd41a4ded646dcecff1cf0733510e4d7"
    sha256 cellar: :any,                 big_sur:        "4d14d5caafcb81dbe582a4ec5174ca2ac659fd406a4cb97c52962b1314172634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7c3514a35b53d8ddff3598956b39bf34fe8b95a873c32117abe99764e4805db"
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
