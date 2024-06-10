class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.12.2.tar.bz2"
  sha256 "34c7770bf0090ee88488af98767d08e779f124fa33437e0aabec8abd4609fec6"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6c82434de971f349f3824c0c5eb3dce5281d7763b6da3a345948355de7d37b1"
    sha256 cellar: :any,                 arm64_ventura:  "78e6c7c86f8b88758d1eff8066b4130aa902989b94abb8ddaf35ffc78e882507"
    sha256 cellar: :any,                 arm64_monterey: "55a7b103f27eba635eb3605550f97298342d53ff09315db1f0fa765585752162"
    sha256 cellar: :any,                 sonoma:         "50be92d7858e7d3eac62eddafc133ec4abdc2bbcd81ac30dd5a1dd00555b3b00"
    sha256 cellar: :any,                 ventura:        "dbde222e31e5c935c707df8f0f7a06dac48c7f9d9dc9ed141f1acf4e8dd32272"
    sha256 cellar: :any,                 monterey:       "91e77574b4d8cc7eab8fbab3e40ea31c7806c25f79654790dc614121d9fe22ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c95d3336f8a2fac401f11a40c0a32e577331500e5dd30ea0641dfd741e9118e"
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
