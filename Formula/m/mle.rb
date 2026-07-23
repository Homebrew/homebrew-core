class Mle < Formula
  desc "Flexible terminal-based text editor"
  homepage "https://github.com/adsr/mle"
  url "https://github.com/adsr/mle/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "7ee33a695f801024254fc717b64aff6a7a4c274874fc4b83e1a23ccf1a74b9ca"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d1fca3abdacc62e424b44f3c6b1fd986636ed1db3b4665ab66c26127e36bfd5e"
    sha256 cellar: :any,                 arm64_sequoia: "404813ee668f4f176f9ca668a77f6b2aef7247e40c4ca154178c8fff5862bc4b"
    sha256 cellar: :any,                 arm64_sonoma:  "fc3b0341e86f538ab1a0790e8df3bf195e91036889ec84a83788547d13dce1d7"
    sha256 cellar: :any,                 sonoma:        "472c405e8d10a960e1414c44a5375a0e23c8e173e48b57147134cf5d20c8e881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba4b8a00e82b00b0be6f1362b7b3a9c757fe5d912894b3b35a4bef0ad81f8548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec050c18c9439ec0a9505ef0c95649c88432ae8fe095f5ecfc53848ee27492c"
  end

  depends_on "uthash" => :build
  depends_on "lua"
  depends_on "pcre2"

  # Backport support for Lua 5.5
  # https://github.com/adsr/mle/commit/3325a1b73d546201c419d9150ff3a10d13ebcb6d
  patch :DATA

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/mle -M 'test C-e space w o r l d enter' -p test", "hello")
    assert_equal "hello world\n", output
  end
end

__END__
diff --git a/Makefile b/Makefile
index 9d77497..7436b03 100644
--- a/Makefile
+++ b/Makefile
@@ -2,8 +2,8 @@ prefix?=/usr/local
 
 mle_cflags:=-std=c99 -Wall -Wextra -pedantic -Wno-pointer-arith -Wno-unused-result -Wno-unused-parameter -g -O0 -D_GNU_SOURCE -DPCRE2_CODE_UNIT_WIDTH=8 -I. $(CFLAGS) $(CPPFLAGS)
 mle_ldflags:=$(LDFLAGS)
-mle_dynamic_libs:=-lpcre2-8 -llua5.4
-mle_static_libs:=vendor/pcre2/libpcre2-8.a vendor/lua/liblua5.4.a
+mle_dynamic_libs:=-lpcre2-8 -llua5.5
+mle_static_libs:=vendor/pcre2/libpcre2-8.a vendor/lua/liblua5.5.a
 mle_ldlibs:=-lm $(LDLIBS)
 mle_objects:=$(patsubst %.c,%.o,$(filter-out %.inc.c,$(wildcard *.c)))
 mle_objects_no_main:=$(filter-out main.o,$(mle_objects))
diff --git a/mle.h b/mle.h
index f77f98f..af7a078 100644
--- a/mle.h
+++ b/mle.h
@@ -4,9 +4,9 @@
 #include <stdint.h>
 #include <limits.h>
 #include <uthash.h>
-#include <lua5.4/lua.h>
-#include <lua5.4/lualib.h>
-#include <lua5.4/lauxlib.h>
+#include <lua5.5/lua.h>
+#include <lua5.5/lualib.h>
+#include <lua5.5/lauxlib.h>
 #include "termbox2.h"
 #include "mlbuf.h"
