class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.10.0.tar.bz2"
  sha256 "097d70e3c8f688e59633ceb8d38ad5c9b0d7ead5729adeb925dbc489437abe13"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a5dcd4e1d24dfd48b0dfc1427f556e4de872f5c23f8995592860ca6169032755"
    sha256 cellar: :any,                 arm64_big_sur:  "519656b434ab049cd5c977daa8158a1eedd64d235375dd88f79cd4b4ea5a58c5"
    sha256 cellar: :any,                 monterey:       "869b4929ca8ea97e372a89edc23408eb17d380bcf7e45f1d188f40b3c093e09f"
    sha256 cellar: :any,                 big_sur:        "91d0a50c7c8dd29ae998bedcbddf35c2b6a6a02152c7bdf972478f82d23b99db"
    sha256 cellar: :any,                 catalina:       "0ed110e809dd1261bb07781440bea89eee125fa64d42a50314281e90004498bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "853cf091be921d6e91f468023b47eb31ad4958ee89e19bfd576f25f5e63ba46d"
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
