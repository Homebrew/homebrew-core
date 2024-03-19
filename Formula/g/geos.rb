class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.12.1.tar.bz2"
  sha256 "d6ea7e492224b51193e8244fe3ec17c4d44d0777f3c32ca4fb171140549a0d03"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eb5ed506791fa7a8d992d675b0fde0caf76a7c2c1969a97f18260489aeb90126"
    sha256 cellar: :any,                 arm64_ventura:  "2e59c5d88e6d77ca35f8a6f206e9e92461ad881471773799e2ca676561d554e4"
    sha256 cellar: :any,                 arm64_monterey: "d7e8fa72281b48b77053d17041c8f7374e9d6e7e6ed8745b7ae14f35ac920111"
    sha256 cellar: :any,                 sonoma:         "058b84baac8fc31b6bc1195e9b457aae1cd4327d016f6ebeb3457fbfe32d6a6b"
    sha256 cellar: :any,                 ventura:        "64e05681743aaaf4c4d0e328d6766b4a8e8f3615bcc07a394e4b3ecd0adedb87"
    sha256 cellar: :any,                 monterey:       "7c2a67de025cee40f7485b54ebece0c8ade16091e8a55595b30a89c3faf6fb0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d49e923f8efb65728637e7bfc6a266dad0e31456e3056dd85d66f36e3925c80"
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
