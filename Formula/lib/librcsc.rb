class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://github.com/helios-base/librcsc"
  url "https://github.com/helios-base/librcsc/archive/refs/tags/rc2024.tar.gz"
  sha256 "81a3f86c9727420178dd936deb2994d764c7cd4888a2150627812ab1b813531b"
  license "LGPL-3.0-or-later"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07beb2a93eae2a1bf5c87a0c7eca366b76d8a90306ce2b50f0cb24e687a30a34"
    sha256 cellar: :any,                 arm64_sequoia: "2c84e2c68411d6172546af9ee7bd2784cfb14441c33dce795fe09d4bb9b2d59d"
    sha256 cellar: :any,                 arm64_sonoma:  "ef91944effe7450efdfc9fd5b38556acbdde006c213b013908931e376ad2067b"
    sha256 cellar: :any,                 sonoma:        "c29606bad6fb82c01c05c08abb5371fe04257723c2dc6a01d530b2521e9d568a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62ddb5361327a271b6707af7a430c9f3b5626fdbdbecd8fad2c5c9d9ac046edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d876f394772c398bd05c2ffc2758343fe35c95929d3e793881291bac5c95311"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "nlohmann-json" => :build
  depends_on "simdjson"

  uses_from_macos "zlib"

  # Add missing header to fix build on Monterey
  # Issue ref: https://github.com/helios-base/librcsc/issues/88
  patch do
    url "https://github.com/helios-base/librcsc/commit/3361f89cf9bb99239a7483783b86de1648d5f359.patch?full_index=1"
    sha256 "cd9df87f8f8dd0c7e3dd0a0bf325b9dd66f8ba9e42cb0e6fab230872dc5ce243"
  end

  # Unbundle simdjson
  patch :DATA

  def install
    # Remove bundled nlohmann-json and simdjson
    rm_r(["rcsc/rcg/nlohmann", "rcsc/rcg/simdjson"])

    # Workaround until upstream removes unnecessary Boost.System link
    boost_workaround = ["--without-boost-system"]

    # Strip linkage to `boost`
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    system "./bootstrap"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
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
