class Cyanrip < Formula
  desc "Bule-ish CD ripper"
  homepage "https://github.com/cyanreg/cyanrip"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/cyanreg/cyanrip/releases/download/v0.9.3.1/cyanrip-src-v0.9.3.1.tar.gz"
    sha256 "fa7bc916ff91a17992b1695fa40dcb17eeeb840cd65c0cf26c1f1ddbc11f42eb"
    patch :DATA
  end

  head do
    url "https://github.com/cyanreg/cyanrip.git"
    patch :DATA
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libcdio"
  depends_on "libcdio-paranoia"
  depends_on "libmusicbrainz"
  uses_from_macos "curl"

  def install
    system "meson", "build", *std_meson_args
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    assert_match(/^cyanrip /, shell_output("#{bin}/cyanrip -V 2>&1"))
    # Ensure it errors properly with no physical disc or image available.
    assert_match(/Unable to init cdio context/, shell_output("#{bin}/cyanrip 2>&1", 1))
  end
end

# without this patch, cyanrip does not run properly
# (the code commented out is supposed to detect a CD being removed
#  but this improperly detects that happening only on macOS)
#
# commenting it out shouldn't cause any adverse issues as far as
# i know from testing, and i'm unsure of any other way to deal with
# this as i can't figure out where the issue would be in libcdio
__END__
diff --git a/src/cyanrip_main.c b/src/cyanrip_main.c
index 58aab36..983fa5b 100644
--- a/src/cyanrip_main.c
+++ b/src/cyanrip_main.c
@@ -609,11 +609,11 @@ repeat_ripping:;
     /* Read the actual CD data */
     for (int i = 0; i < frames; i++) {
         /* Detect disc removals */
-        if (cdio_get_media_changed(ctx->cdio)) {
-            cyanrip_log(ctx, 0, "\nDrive media changed, stopping!\n");
-            ret = AVERROR(EINVAL);
-            goto fail;
-        }
+        //if (cdio_get_media_changed(ctx->cdio)) {
+        //    cyanrip_log(ctx, 0, "\nDrive media changed, stopping!\n");
+        //    ret = AVERROR(EINVAL);
+        //    goto fail;
+        //}
 
         /* Flush paranoia cache if overreading into lead-out - no idea why */
         if ((t->start_lsn + i) > ctx->end_lsn)
