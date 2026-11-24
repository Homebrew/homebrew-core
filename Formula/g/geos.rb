class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.15.1.tar.bz2"
  sha256 "8eb6dc2ea78b00c2f5109c6b0dba9e028c60bad42d7b1b0cc9952b12dc71f571"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "24191e70a4620dce11dbf7ba321b2dfcfb5926e05ad9b42da4afa3f699b1f2d4"
    sha256 cellar: :any, arm64_golden_gate: "7355fc188c9cef6f9b726bbe95e1f5d6058f78e672cf4146c32afc57a3fe25ff"
    sha256 cellar: :any, arm64_tahoe:       "be86a5e10f911c883285f609535d0f42dbe68ca42c821b186b2426e85a506445"
    sha256 cellar: :any, arm64_sequoia:     "8baedc5643ae9f13cfc326ee8fbe810007de8863be3843aa68a346b5e3928ab8"
    sha256 cellar: :any, arm64_linux:       "d10fe11f5e95bcdc5aae5ad50a5981a66678685ae782f262b89a66f845995765"
    sha256 cellar: :any, x86_64_linux:      "0106c09356c3b1b808ea9055b7f0795345e36ab678af05b0259804e4eba3d02b"
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
