class Ekg2 < Formula
  desc "Multiplatform, multiprotocol, plugin-based instant messenger"
  homepage "https://github.com/ekg2/ekg2"
  url "https://src.fedoraproject.org/lookaside/extras/ekg2/ekg2-0.3.1.tar.gz/68fc05b432c34622df6561eaabef5a40/ekg2-0.3.1.tar.gz"
  mirror "https://web.archive.org/web/20161227025528/pl.ekg2.org/ekg2-0.3.1.tar.gz"
  sha256 "6ad360f8ca788d4f5baff226200f56922031ceda1ce0814e650fa4d877099c63"
  revision 3

  bottle do
    sha256 "0743656772367528b12696d599be81d46a0f2dffd8599b7331da7dc2c46fa404" => :mojave
    sha256 "4415b63628ac3a3f2e43419bbbdacd17184e3e23913b26bcc87152fc0a91a4ae" => :high_sierra
    sha256 "bb1c5ca15114cdd1b9f93cf1db9fc544cfdd1edc4f9fc31e0891627d738ad027" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "readline"

  # Fix the build on OS X 10.9+
  # http://bugs.ekg2.org/issues/152
  patch :DATA

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
