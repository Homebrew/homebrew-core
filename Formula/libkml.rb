class Libkml < Formula
  desc "Library to parse, generate and operate on KML"
  homepage "https://code.google.com/archive/p/libkml/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkml/libkml-1.2.0.tar.gz"
  sha256 "fae9085e4cd9f0d4ae0d0626be7acf4ad5cbb37991b9d886df29daf72df37cbc"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_monterey: "93812e697f75c3ddebdb3f15b8b7e98773c49c69e929a244439c66076f81ff76"
    sha256 cellar: :any, arm64_big_sur:  "589b147706bc4aec04f96039cb2e61e80d85bcbedf0e919ebcca29fe09d81e26"
    sha256 cellar: :any, monterey:       "a217fb8977e5923462c00746cd607f510e76a9a20be9c53db554f5c72ffdfeef"
    sha256 cellar: :any, big_sur:        "a0694686c535fa33f6222e11dde9858881e6a5eaa12c6b11c5ef310a32635087"
    sha256 cellar: :any, catalina:       "2b73d6ea2eacd6e11229a0a9747444c28a455bb24943108b0351f689d17eb3d9"
    sha256 cellar: :any, mojave:         "c79c73e048728d0497b7f91c0e174bd97e27f65ff471e00324483a3557b6a13f"
    sha256 cellar: :any, high_sierra:    "31d567e2e0d87794adea3507cb34ace0483309de7ba5b32fc98bc1ca59a461c5"
    sha256 cellar: :any, sierra:         "860294d677de2f8a4c18e4d750d59aeafa2b38801b12eb76b5e951a23a8ec108"
    sha256 cellar: :any, el_capitan:     "57b9693cdf9a6abaeeea9648cd84a81d17ba0f056bd8d8e8442e68d97dbc7828"
    sha256 cellar: :any, yosemite:       "a3cdfca3ed0acbc93949683a8bb2862c36ec8bf06f20b9fe3752ac624667f455"
  end

  conflicts_with "uriparser", because: "both install `liburiparser.dylib`"

  # Fix compilation with clang and gcc 4.7+
  # https://code.google.com/p/libkml/issues/detail?id=179
  patch :DATA

  # Correct an issue where internal third-party libs (libminizip and liburiparser)
  # are installed as dylibs. liburiparser conflicts with uriparser formula.
  # libminizip conflicts with new formula, and some of its symbols have been
  # renamed with prefixes of "libkml_", i.e, can't be linked against for other builds
  # Fix just forces internal libs to be linked statically until the following
  # is addressed upstream: https://code.google.com/p/libkml/issues/detail?id=50
  patch do
    url "https://gist.githubusercontent.com/dakcarto/7419882/raw/10ae08af224b3fee0617fa6288d806d3ccf37c0f/libkml-1.2-static-deps"
    sha256 "c39995a1c1ebabc1692dc6be698d68e18170230d71d5a0ce426d8f41bdf0dc72"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/src/kml/base/file_posix.cc b/src/kml/base/file_posix.cc
index 764ae55..8ee9892 100644
--- a/src/kml/base/file_posix.cc
+++ b/src/kml/base/file_posix.cc
@@ -29,6 +29,7 @@
 #include "kml/base/file.h"
 #include <stdlib.h>
 #include <string.h>
+#include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
