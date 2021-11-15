class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.10.1.tar.bz2"
  sha256 "a8148eec9636814c8ab0f8f5266ce6f9b914ed65b0d083fc43bb0bbb01f83648"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4480b5c6681e03dc42f75a0f90551a253c9de3c95d250cd77c60014806735155"
    sha256 cellar: :any,                 arm64_big_sur:  "7c8880d253274db92992bb2ac5ba988d13e9a90a366d45d6d8d95bf3a034d98b"
    sha256 cellar: :any,                 monterey:       "712ef045ef32864ad97ab88232567aaad7b63327cd48d418a509cb80a3f9ab3a"
    sha256 cellar: :any,                 big_sur:        "f462c830dd04b4387bf86d8d589ba047ed8eb25b78dd366223e577ac3f074660"
    sha256 cellar: :any,                 catalina:       "7d9e28e907668c1b0864a8011d002b26f0c16b5880c6c2470f6dd08a47d9ca2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a182a9635ec806025fcd1ef7d471792b324c6091646c664149382611da59914d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
