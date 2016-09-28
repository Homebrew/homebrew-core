class Aview < Formula
  desc "ASCII-art image browser and animation viewer"
  homepage "http://aa-project.sourceforge.net/aview/"
  url "https://downloads.sourceforge.net/aa-project/aview-1.3.0rc1.tar.gz"
  sha256 "42d61c4194e8b9b69a881fdde698c83cb27d7eda59e08b300e73aaa34474ec99"

  bottle do
    cellar :any_skip_relocation
    sha256 "95cbb14a2a5cb4d8d11d9ca3621e81705df77f47d85f89383913e3a02da56041" => :sierra
    sha256 "cb20b8513b3b7d2977943d7ba14f2627892697e9a6b69c4366563786810ca95c" => :el_capitan
    sha256 "886a6800deefcf7a1e377db57c9df0579b6f1fcb4b491a6262171411bce3517b" => :yosemite
    sha256 "142a0b64e457e900e395f35d5112bd968e605fa6182bdc9ca77b923a5e5263f6" => :mavericks
  end

  depends_on "aalib"

  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
diff --git a/image.c b/image.c
index 232b838..9780e61 100644
--- a/image.c
+++ b/image.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 #include <unistd.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include "config.h"
 
 int imgwidth, imgheight;
diff --git a/ui.c b/ui.c
index d316f7a..134a4ca 100644
--- a/ui.c
+++ b/ui.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 #include <ctype.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 #include <aalib.h>
 #include "shrink.h"

