class Ekg2 < Formula
  desc "Multiplatform, multiprotocol, plugin-based instant messenger"
  homepage "https://github.com/ekg2/ekg2"
  url "https://src.fedoraproject.org/lookaside/extras/ekg2/ekg2-0.3.1.tar.gz/68fc05b432c34622df6561eaabef5a40/ekg2-0.3.1.tar.gz"
  mirror "https://web.archive.org/web/20161227025528/pl.ekg2.org/ekg2-0.3.1.tar.gz"
  sha256 "6ad360f8ca788d4f5baff226200f56922031ceda1ce0814e650fa4d877099c63"
  revision 4

  bottle do
    sha256 "e17ea1385008892e80e0d5e0d44e510f6ac30e5d86423b55c61465eccd348d36" => :catalina
    sha256 "78778e95338d2a0a61f7d4773716d927534d24e4d5867a04038401427b07c855" => :mojave
    sha256 "f946e56a032b9526280745e6e57f8bc42a18d12fa9ced783f5515eb600bcdf0b" => :high_sierra
    sha256 "35f01a57bbceb1a79abfa8b035e3135d0c821bbca22a63b273e32159e517813f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  # Fix the build on OS X 10.9+
  # bugs.ekg2.org/issues/152 [LOST LINK]
  patch :DATA

  # Upstream commit, fix build against OpenSSL 1.1
  patch do
    url "https://github.com/ekg2/ekg2/commit/f05815.diff?full_index=1"
    sha256 "5a27388497fd4537833807a0ba064af17fa13d7dd55abec6b185f499d148de1a"
  end

  def install
    readline = Formula["readline"].opt_prefix

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-unicode
      --with-readline=#{readline}
      --without-gtk
      --without-libgadu
      --without-perl
      --without-python
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/ekg2", "--help"
  end
end

__END__
diff --git a/compat/strlcat.c b/compat/strlcat.c
index 6077d66..c1c1804 100644
--- a/compat/strlcat.c
+++ b/compat/strlcat.c
@@ -14,7 +14,7 @@
  *  License along with this program; if not, write to the Free Software
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#ifndef strlcat
 #include <sys/types.h>

 size_t strlcat(char *dst, const char *src, size_t size)
@@ -39,7 +39,7 @@ size_t strlcat(char *dst, const char *src, size_t size)

	return dlen + j;
 }
-
+#endif
 /*
  * Local Variables:
  * mode: c
diff --git a/compat/strlcat.h b/compat/strlcat.h
index cb91fcb..df8f4b0 100644
--- a/compat/strlcat.h
+++ b/compat/strlcat.h
@@ -1,7 +1,8 @@
+#ifndef strlcat
 #include <sys/types.h>

 size_t strlcat(char *dst, const char *src, size_t size);
-
+#endif
 /*
  * Local Variables:
  * mode: c
diff --git a/compat/strlcpy.c b/compat/strlcpy.c
index 31e41bd..4a40762 100644
--- a/compat/strlcpy.c
+++ b/compat/strlcpy.c
@@ -14,7 +14,7 @@
  *  License along with this program; if not, write to the Free Software
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#ifndef strlcpy
 #include <sys/types.h>

 size_t strlcpy(char *dst, const char *src, size_t size)
@@ -32,7 +32,7 @@ size_t strlcpy(char *dst, const char *src, size_t size)

	return i;
 }
-
+#endif
 /*
  * Local Variables:
  * mode: c
diff --git a/compat/strlcpy.h b/compat/strlcpy.h
index 1c80e20..93340af 100644
--- a/compat/strlcpy.h
+++ b/compat/strlcpy.h
@@ -1,7 +1,8 @@
+#ifndef strlcpy
 #include <sys/types.h>

 size_t strlcpy(char *dst, const char *src, size_t size);
-
+#endif
 /*
  * Local Variables:
  * mode: c
