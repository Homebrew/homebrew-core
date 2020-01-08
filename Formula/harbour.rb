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
    rebuild 2
    sha256 "a782b441606f27f4c2b4708faa78b980b675c5e1e4b8a3d9ab4f2df7f6df8b0a" => :catalina
    sha256 "38063770c90226c48e9d73c6789a015141ac0db6478d075fe18f5d8718e2472d" => :mojave
    sha256 "efcb46128115bea60eab289f581c4bed82fa846af095055feee116cbf90ed9ac" => :high_sierra
    sha256 "ddf71a29c41a874b1d6e787d07f8f66d284ac2bbc24c7a77c1dedfe8d243c76a" => :sierra
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
