class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.51.tar.bz2"
  sha256 "be0f1b2db6b93eed55369cdf79f19f72750c8c7c39fc20b577e724545427e6b2"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "7db996510272893e4db9cd536e65e7fa6d0f20c4dbef13c55e95a3ebab67d103"
    sha256 arm64_sonoma:  "92893cbf03a9de9c16bc05f67e2bb6ab257ad2108aa61bdf1cea6178ac2dcac7"
    sha256 arm64_ventura: "88f92f8777d3dbe2e163ea5736727b804a843ed707fcf270991a853943df686a"
    sha256 sonoma:        "cb513c9b9bc05125027e8dee2b2f6ae5a7288ca27ee28aed032086f6f1a9629a"
    sha256 ventura:       "a184d3d66348ce9885b39561a7c6f98bdaae83791400c018f2634720889cd10d"
    sha256 x86_64_linux:  "9b65876e4b4b45e6111dd0047e8a3ebb46df26a42d75fc2af41e91beca83ee7d"
  end

  on_macos do
    depends_on "gettext"
  end

  # Declare environ - upstream bug https://dev.gnupg.org/T7169
  patch :DATA

  def install
    # NOTE: gpg-error-config is deprecated upstream, so we should remove this at some point.
    # https://dev.gnupg.org/T5683
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-install-gpg-error-config",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace [bin/"gpg-error-config", lib/"pkgconfig/gpg-error.pc"], prefix, opt_prefix
  end

  test do
    system bin/"gpgrt-config", "--libs"
  end
end

__END__
--- a/src/spawn-posix.c
+++ b/src/spawn-posix.c
@@ -57,7 +57,10 @@
 
 #include "gpgrt-int.h"
 
+/* (Only glibc's unistd.h declares this iff _GNU_SOURCE is used.)  */
+extern char **environ;
+ 
 
 /* Definition for the gpgrt_spawn_actions_t.  Note that there is a
  * different one for Windows.  */
 struct gpgrt_spawn_actions {

