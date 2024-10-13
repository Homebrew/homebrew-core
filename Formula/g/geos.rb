class Geos < Formula
  desc "Geometry Engine"
  homepage "https://libgeos.org/"
  url "https://download.osgeo.org/geos/geos-3.13.0.tar.bz2"
  sha256 "47ec83ff334d672b9e4426695f15da6e6368244214971fabf386ff8ef6df39e4"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d07e0287c32e0742bf62253fc48f3384bb385b4384973af995c1c8eef7f11361"
    sha256 cellar: :any,                 arm64_sonoma:   "7598e3f97042c2dc4442e77feb4e8d3af4cd0fe58922ad99644134be1172b815"
    sha256 cellar: :any,                 arm64_ventura:  "012ee44940537761cf2da1f0bb120389dac8f7bae8c392b849cc383402ad2d0c"
    sha256 cellar: :any,                 arm64_monterey: "6ffce2acd56557396bc6013265d9c05f4c74ba9d3ae6f5c17d82540fc9f1ae6e"
    sha256 cellar: :any,                 sonoma:         "b59f7be995ac70f363ec0141a7be9a42d613f37546706ed42d4c219c06519daf"
    sha256 cellar: :any,                 ventura:        "150710ce1adbad6392e7a5f454cbd99440314dca20acf5fc916cda1fec428f2d"
    sha256 cellar: :any,                 monterey:       "e571b0cb00d55a304164afc584d75b1e0bef8f208cf324470bf8acac8e9118d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c0af95be5136b4a47d1a841e85326cdf7e8ad25f83b074b29d2b6752172541c"
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
