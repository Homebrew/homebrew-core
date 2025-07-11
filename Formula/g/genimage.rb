class Genimage < Formula
  desc "Tool to generate multiple filesystem and flash images from a tree"
  homepage "https://github.com/pengutronix/genimage"
  url "https://github.com/pengutronix/genimage/archive/refs/tags/v18.tar.gz"
  sha256 "af555b9d9f17301ab4cc2cda4849afd88d2b97ae4cc8badb9b8448299d6f6080"
  license "GPL-2.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "confuse"
  depends_on "genext2fs"

  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/genimage --help")
  end
end

__END__
diff --git a/config.c b/config.c
index 431cac9..80eb143 100644
--- a/config.c
+++ b/config.c
@@ -259,7 +259,7 @@ static char *abspath(const char *path)
 	if (*path == '/')
 		return strdup(path);
 
-	xasprintf(&p, "%s/%s", get_current_dir_name(), path);
+	xasprintf(&p, "%s/%s", getcwd(NULL, PATH_MAX), path);
 
 	return p;
 }
diff --git a/image-android-sparse.c b/image-android-sparse.c
index b0caad5..bacc75b 100644
--- a/image-android-sparse.c
+++ b/image-android-sparse.c
@@ -15,7 +15,9 @@
  */
 
 #include <confuse.h>
-#include <endian.h>
+#include <libkern/OSByteOrder.h>
+#define htole16(x) OSSwapHostToLittleInt16(x)
+#define htole32(x) OSSwapHostToLittleInt32(x)
 #include <errno.h>
 #include <fcntl.h>
 #include <stdlib.h>
diff --git a/image-hd.c b/image-hd.c
index 5658c50..af32e6e 100644
--- a/image-hd.c
+++ b/image-hd.c
@@ -22,7 +22,10 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <inttypes.h>
-#include <endian.h>
+#include <libkern/OSByteOrder.h>
+#define htole16(x) OSSwapHostToLittleInt16(x)
+#define htole32(x) OSSwapHostToLittleInt32(x)
+#define htole64(x) OSSwapHostToLittleInt64(x)
 #include <stdbool.h>
 #include <unistd.h>
 #include <sys/types.h>
diff --git a/image-rauc.c b/image-rauc.c
index 8f405e4..e68f0cd 100644
--- a/image-rauc.c
+++ b/image-rauc.c
@@ -97,7 +97,7 @@ static int rauc_generate(struct image *image)
 		}
 
 		/* create parent directories if target needs it */
-		path = strdupa(target);
+		path = strdup(target);
 		tmp = strrchr(path, '/');
 		if (tmp) {
 			*tmp = '\0';
diff --git a/image-vfat.c b/image-vfat.c
index d3735de..60d64ea 100644
--- a/image-vfat.c
+++ b/image-vfat.c
@@ -47,7 +47,7 @@ static int vfat_generate(struct image *image)
 		struct image *child = image_get(part->image);
 		const char *file = imageoutfile(child);
 		const char *target = part->name;
-		char *path = strdupa(target);
+		char *path = strdup(target);
 		char *next = path;
 
 		while ((next = strchr(next, '/')) != NULL) {
