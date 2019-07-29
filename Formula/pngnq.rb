class Pngnq < Formula
  desc "Tool for optimizing PNG images"
  homepage "https://pngnq.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pngnq/pngnq/1.1/pngnq-1.1.tar.gz"
  sha256 "c147fe0a94b32d323ef60be9fdcc9b683d1a82cd7513786229ef294310b5b6e2"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "2287986066f131dbcac5ab97b033898a611b2b07348847ce5094f09bba06c7fa" => :mojave
    sha256 "258abdbd2805617e3c36c0926b3168e0632d3eafacba9e9b63c8e35dee6c28f7" => :high_sierra
    sha256 "0914104edfd7c6089ae4b053e5a57cf1b5a0d9bb476424ce654a923cafef651c" => :sierra
    sha256 "dd6970fb9055fb1a6702c820e75a3d7b826e165e61c23c17b0845cca780c3da9" => :el_capitan
    sha256 "cba40b130f3d16666580be2b572721d0d8d312f60f62e4fdef656ffa825bc65e" => :yosemite
    sha256 "4d9e35ec7c627bd2dc8c1ca26982e9c93e0a74687600830d5d491587ec04f967" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  # Fixes compilation on OSX Lion
  # png.h on Lion does not, in fact, include zlib.h
  # See: https://sourceforge.net/p/pngnq/bugs/13/
  # See: https://sourceforge.net/p/pngnq/bugs/14/
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end


__END__
diff --git a/src/rwpng.c b/src/rwpng.c
index aaa21fc..5324afe 100644
--- a/src/rwpng.c
+++ b/src/rwpng.c
@@ -31,6 +31,7 @@

 #include <stdio.h>
 #include <stdlib.h>
+#include <zlib.h>

 #include "png.h"        /* libpng header; includes zlib.h */
 #include "rwpng.h"      /* typedefs, common macros, public prototypes */
