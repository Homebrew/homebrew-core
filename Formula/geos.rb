class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.11.1.tar.bz2"
  sha256 "6d0eb3cfa9f92d947731cc75f1750356b3bdfc07ea020553daf6af1c768e0be2"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9750b3496da8c44a49c4c4489c1e4a3232ec609cf97ea70bc34bd9db4ef60b0a"
    sha256 cellar: :any,                 arm64_monterey: "12545b3c2976b4f7598ba16e28a3a6df73dd0fcb28444ce1e913e6522d510770"
    sha256 cellar: :any,                 arm64_big_sur:  "49e7548ee22cf9fe67a14c9324b06871a2ea730e807676d7ab2cfc4a5660e8d7"
    sha256 cellar: :any,                 ventura:        "f10ded36947f353f140ac312c7f337d950993f4bb0b12fc12704e7ff85f57ee2"
    sha256 cellar: :any,                 monterey:       "6e51f012221d4e8900f7ba72be4d6d3664c29022c3106d43de412989141ca3c5"
    sha256 cellar: :any,                 big_sur:        "db3008471b5f37ae7cde2a734c3f3e939159bf118149f8616e184f9ea715825a"
    sha256 cellar: :any,                 catalina:       "64e309838456b245c85401c200799a9fbaaf35e36c17ca52d79c7ee141acb306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c04b4438271d959c4e9752e7c9c1b56f855841c01d369f826a59b3c25e7ef55f"
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
