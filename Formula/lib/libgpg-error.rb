class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.55.tar.bz2"
  sha256 "95b178148863f07d45df0cea67e880a79b9ef71f5d230baddc0071128516ef78"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a2d0e274ace59980a81d2b06c445ddef5498c69cbefc85bdf04d3d79d0dfd71d"
    sha256 arm64_sonoma:  "3ef3920eef9d7f025f528e438ec467d763bfe595e11a5763f0c63fb6dd40aeae"
    sha256 arm64_ventura: "d0067e8720929efdf81cc5b5dd9b3b05ca7d7dccbdc7e3178e25103f2e85ccdf"
    sha256 sonoma:        "031f35425ad74efb6299dec9832896c281c630d672c65559bd9dd62c256be76c"
    sha256 ventura:       "5ad9a39d350da42b905a240de2910ccea43a320b23a56e557d934deafb986c30"
    sha256 arm64_linux:   "142ea10cc7ccbcfc02f233a3c8f18cb2c90964bb0164da7335a9caa9d08abf1b"
    sha256 x86_64_linux:  "78119cb448e954ceba1461b93a80700168ecf3b9e330a39f5b3a6f195d162607"
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

