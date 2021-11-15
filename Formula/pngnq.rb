class Pngnq < Formula
  desc "Tool for optimizing PNG images"
  homepage "https://pngnq.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pngnq/pngnq/1.1/pngnq-1.1.tar.gz"
  sha256 "c147fe0a94b32d323ef60be9fdcc9b683d1a82cd7513786229ef294310b5b6e2"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "31c85fafb9fd2051db06856042a3f216f9fd24fbfd8acf95f5a51bf695989a02"
    sha256 cellar: :any, arm64_big_sur:  "21e94d2f987e060920488bdaf121792282548dcf196eed01e4fd5221db414685"
    sha256 cellar: :any, monterey:       "d84ba4d373165ff3999b3c20e49ebdc69f8374a7c04a6fa48fc68d337a2e5924"
    sha256 cellar: :any, big_sur:        "42695d06f657acabd7c229206d3623ca3830667c4ab1308d5371cbca7beb48bd"
    sha256 cellar: :any, catalina:       "f438c5d73e9dd9c3c36283aa9f8253168de30f52242955a803714350cc247c80"
    sha256 cellar: :any, mojave:         "2287986066f131dbcac5ab97b033898a611b2b07348847ce5094f09bba06c7fa"
    sha256 cellar: :any, high_sierra:    "258abdbd2805617e3c36c0926b3168e0632d3eafacba9e9b63c8e35dee6c28f7"
    sha256 cellar: :any, sierra:         "0914104edfd7c6089ae4b053e5a57cf1b5a0d9bb476424ce654a923cafef651c"
    sha256 cellar: :any, el_capitan:     "dd6970fb9055fb1a6702c820e75a3d7b826e165e61c23c17b0845cca780c3da9"
    sha256 cellar: :any, yosemite:       "cba40b130f3d16666580be2b572721d0d8d312f60f62e4fdef656ffa825bc65e"
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
