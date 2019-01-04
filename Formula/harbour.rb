class Harbour < Formula
  desc "Portable, xBase-compatible programming language and environment"
  homepage "https://harbour.github.io"
  head "https://github.com/harbour/core.git"

  # Missing a header that was deprecated by libcurl @ version 7.12.0 and
  # deleted sometime after Harbour 3.0.0 release.
  stable do
    patch :DATA
    url "https://downloads.sourceforge.net/harbour-project/source/3.0.0/harbour-3.0.0.tar.bz2"
    sha256 "4e99c0c96c681b40c7e586be18523e33db24baea68eb4e394989a3b7a6b5eaad"
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "feb82703d6fbf9d406f32b825d44bcf2fd40867a262a20df52f1b732863bc702" => :mojave
    sha256 "3b7edfe9c3878bbfe632cca9abc40a4b109b420b7ab856b90ce44fbc05624f85" => :high_sierra
    sha256 "815dacae2d2ac3d7e9c16d158a42e3bc500758f6d30fc5d0eedec8ae88b1bf26" => :sierra
    sha256 "21c3269b41d9b8ea334949334febed047c7ffd4fc9ca7e0686ba6a472929a2b8" => :el_capitan
    sha256 "5677878ce808eb51cf130212724d1959def64d45c6812cb99ec0ceef100ea4f8" => :yosemite
    sha256 "ed55f20628aa2c34adccb0530a9b8f477572bc8acc0d9ff3d5374fe68384c753" => :mavericks
    sha256 "8b6384af586eeec66714a8c55e5e6efb26909053958897b64c7cdad2459965e0" => :mountain_lion
  end

  depends_on "pcre"

  def install
    ENV["HB_INSTALL_PREFIX"] = prefix
    ENV["HB_WITH_X11"] = "no"

    ENV.deparallelize

    system "make", "install"

    rm Dir[bin/"hbmk2.*.hbl"]
    rm bin/"contrib.hbr" if build.head?
    rm bin/"harbour.ucf" if build.head?
  end

  test do
    (testpath/"hello.prg").write <<~EOS
      procedure Main()
         OutStd( ;
            "Hello, world!" + hb_eol() + ;
            OS() + hb_eol() + ;
            Version() + hb_eol() )
         return
    EOS

    assert_match /Hello, world!/, shell_output("#{bin}/hbmk2 hello.prg -run")
  end
end

__END__
diff --git a/contrib/hbcurl/core.c b/contrib/hbcurl/core.c
index 00caaa8..53618ed 100644
--- a/contrib/hbcurl/core.c
+++ b/contrib/hbcurl/core.c
@@ -53,8 +53,12 @@
  */

 #include <curl/curl.h>
-#include <curl/types.h>
-#include <curl/easy.h>
+#if LIBCURL_VERSION_NUM < 0x070A03
+#  include <curl/easy.h>
+#endif
+#if LIBCURL_VERSION_NUM < 0x070C00
+#  include <curl/types.h>
+#endif

 #include "hbapi.h"
 #include "hbapiitm.h"
