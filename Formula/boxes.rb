class Boxes < Formula
  desc "Draw boxes around text"
  homepage "http://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v1.1.2.tar.gz"
  sha256 "4d5e536be91b476ee48640bef9122f3114b16fe2da9b9906947308b94682c5fe"
  revision 1
  head "https://github.com/ascii-boxes/boxes.git"

  bottle do
    rebuild 1
    sha256 "21b2548489c34f7a11ac4f445e9129fbc42696a6dba5b50b20aeec99a570fef2" => :sierra
    sha256 "d5a5b256a1ef58a8d9c3d69c57c27bb8dd5c5e40e8979f877f83278ff38fd950" => :el_capitan
    sha256 "ee8b2795856fafcfaad79356325d7e1cf6aaa02359cb9adf162df2028243f429" => :yosemite
    sha256 "4d82f6e37b1e18d48a2198ca4301d901e4a6b55681ed8f0b65dddeee1148221e" => :mavericks
  end

  # Patch to fix 64-bit compilation
  # https://github.com/ascii-boxes/boxes/issues/38
  patch :DATA

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config", "CC=#{ENV.cc}"

    bin.install "src/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "/* test brew */", pipe_output("#{bin}/boxes", "test brew")
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index c2656df..db19d29 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -62,7 +62,7 @@ boxes.exe: $(ALL_OBJ)
 
 
 flags_unix:
-	$(eval CFLAGS := -ansi -I. -Iregexp -Wall -W $(CFLAGS_ADDTL))
+	$(eval CFLAGS := -I. -Iregexp -Wall -W $(CFLAGS_ADDTL))
 	$(eval LDFLAGS := -Lregexp $(LDFLAGS_ADDTL))
 	$(eval BOXES_EXECUTABLE_NAME := boxes)
 	$(eval ALL_OBJ := $(GEN_SRC:.c=.o) $(ORIG_NORM:.c=.o))


diff --git a/src/parser.y b/src/parser.y
index c9acfbd..a32ef36 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -27,6 +27,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <strings.h>
 #include "shape.h"
 #include "boxes.h"
 #include "tools.h"
