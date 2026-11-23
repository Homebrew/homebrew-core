class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://github.com/helios-base/librcsc"
  url "https://github.com/helios-base/librcsc/archive/refs/tags/rc2026.tar.gz"
  sha256 "876d2903eace3f46be3a91b184ccce96a7885c73903c0e73d52cf0df3d79b9d5"
  license "LGPL-3.0-or-later"
  revision 5

  bottle do
    manifest_sha256 "daaa2306b41462e67d929cf811784de4771d9095a86a9f424030c2c69ed1dedb"
    sha256 cellar: :any, arm64_golden_gate: "19cf9fd65b42c6ffb7613868db311281f91779da844f89bcb6ea125ead8da3e4"
    sha256 cellar: :any, arm64_tahoe:       "74c528c1e696d5b31a4063184429339e4c8092e288201d9f6436df043dc05bc0"
    sha256 cellar: :any, arm64_sequoia:     "5eb2838d53794512bf14bb818f66c02a195ad80309bf04d20fb802aeb81e5435"
    sha256 cellar: :any, arm64_linux:       "f35907c3d711b3f86c8fe7da9dbd55f7dd9128c2cefb3d299c68a82bad11ae11"
    sha256 cellar: :any, x86_64_linux:      "9e3256e268d050f48ee09bbe166858bcca5e1e67c17089bc964a4710929bd359"
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
