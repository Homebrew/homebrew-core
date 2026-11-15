class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://github.com/helios-base/librcsc"
  url "https://github.com/helios-base/librcsc/archive/refs/tags/rc2026.tar.gz"
  sha256 "876d2903eace3f46be3a91b184ccce96a7885c73903c0e73d52cf0df3d79b9d5"
  license "LGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e17823d2045aa373c7216a2813a6d28cebe37de2e4490ef47683bb589bd781d3"
    sha256 cellar: :any, arm64_tahoe:       "de05fbbe79e807b3e229f6180b6b8a04b9b991dd8321d8ed63346409d383728b"
    sha256 cellar: :any, arm64_sequoia:     "e11dc2ba1f3df070983af0729395a3920246c634fb75b9e57c0e97ec1521d8fd"
    sha256 cellar: :any, arm64_linux:       "e2b6bffea14ab2b7045a680780071e15b6064a1304df4aad16e890c25f6516c3"
    sha256 cellar: :any, x86_64_linux:      "c82481ab05a9b3d68eece877de643ca1be61fc037fe28ed6c8c5db7d5f45f25b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "nlohmann-json" => :build
  depends_on "simdjson"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Unbundle simdjson
  patch :DATA

  deny_network_access!

  def install
    # Remove bundled nlohmann-json and simdjson
    rm_r(["rcsc/rcg/nlohmann", "rcsc/rcg/simdjson"])

    # Workaround until upstream removes unnecessary Boost.System link
    boost_workaround = ["--without-boost-system"]

    # Strip linkage to `boost`
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?
    ENV.append "CFLAGS", "-std=gnu11"

    system "./bootstrap"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{formula_opt_prefix("boost")}",
                          *boost_workaround,
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <rcsc/rcg.h>
      int main() {
        rcsc::rcg::PlayerT p;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-lrcsc"
    system "./test"
  end
end

__END__
diff --git a/rcsc/rcg/Makefile.am b/rcsc/rcg/Makefile.am
index 819c63a..4bac46f 100644
--- a/rcsc/rcg/Makefile.am
+++ b/rcsc/rcg/Makefile.am
@@ -6,7 +6,6 @@ noinst_LTLIBRARIES = librcsc_rcg.la
 #lib_LTLIBRARIES = librcsc_rcg.la
 
 librcsc_rcg_la_SOURCES = \
-	simdjson/simdjson.cpp \
 	handler.cpp \
 	parser.cpp \
 	parser_v1.cpp \
@@ -47,9 +46,10 @@ librcsc_rcginclude_HEADERS = \
 	types.h \
 	util.h
 
-noinst_HEADERS = \
-	simdjson/simdjson.h
+noinst_HEADERS =
 
+librcsc_rcg_la_CXXFLAGS = -DSIMDJSON_THREADS_ENABLED=1
+librcsc_rcg_la_LIBADD = -lsimdjson
 librcsc_rcg_la_LDFLAGS = -version-info 6:0:0
 #libXXXX_la_LDFLAGS = -version-info $(LT_CURRENT):$(LT_REVISION):$(LT_AGE)
 #		 1. Start with version information of `0:0:0' for each libtool library.
@@ -76,8 +76,7 @@ AM_CFLAGS = -Wall -W
 AM_CXXFLAGS = -Wall -W
 AM_LDFLAGS =
 
-EXTRA_DIST = \
-	simdjson/LICENSE
+EXTRA_DIST =
 
 CLEANFILES = *~
 
diff --git a/rcsc/rcg/parser_simdjson.cpp b/rcsc/rcg/parser_simdjson.cpp
index 019d482..a5eca8c 100644
--- a/rcsc/rcg/parser_simdjson.cpp
+++ b/rcsc/rcg/parser_simdjson.cpp
@@ -39,7 +39,7 @@
 #include "types.h"
 #include "util.h"
 
-#include "simdjson/simdjson.h"
+#include "simdjson.h"
 
 #include <unordered_map>
 #include <string_view>
