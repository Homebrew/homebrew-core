class Boxes < Formula
  desc "Draw boxes around text"
  homepage "http://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v1.1.2.tar.gz"
  sha256 "4d5e536be91b476ee48640bef9122f3114b16fe2da9b9906947308b94682c5fe"
  revision 1
  head "https://github.com/ascii-boxes/boxes.git"

  bottle do
    sha256 "20ab01b5e25afba5ee98838faf4efe25f0b9c1ca729ab1e6b5136cb09423ef67" => :sierra
    sha256 "bb0d5b9f24c531aaa9b45e09868073547ac0f1bc94ed39021c03f31cf8ed284b" => :el_capitan
    sha256 "8fe10850d2df635ca8800e826fa542be10e47a8c1a9da8ed2111245c61129ff7" => :yosemite
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
