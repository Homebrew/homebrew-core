class Ekg2 < Formula
  desc "Multiplatform, multiprotocol, plugin-based instant messenger"
  homepage "http://en.ekg2.org"
  url "http://pl.ekg2.org/ekg2-0.3.1.tar.gz"
  sha256 "6ad360f8ca788d4f5baff226200f56922031ceda1ce0814e650fa4d877099c63"
  revision 2

  bottle do
    sha256 "77d62ccb6a0ff4e9126850aa1c5287e583cc5f643f6fbe2505199e694de7a337" => :sierra
    sha256 "34a9b94c6161be85b1b42a57395528982965357cffd7f4771456c01309fb402e" => :el_capitan
    sha256 "dafaf67dca8fefd62b5e76ec03c8d71a85542d04157e53e0ceb915475a2c5067" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "libgadu" => :optional
  depends_on "openssl"

  # Fix the build on OS X 10.9+
  # http://bugs.ekg2.org/issues/152
  patch :DATA

  def install
    readline = Formula["readline"].opt_prefix

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-python
      --without-perl
      --with-readline=#{readline}
      --without-gtk
      --enable-unicode
    ]

    args << (build.with?("libgadu") ? "--with-libgadu" : "--without-libgadu")

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
