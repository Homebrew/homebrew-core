class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.53.tar.bz2"
  sha256 "6a0721b52027415f53abcbf63b5c37776a0f774d9126d560a3ce76c0eb42903f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "220358478d50a3f9f62659ae5da02cce0ff62a138c1f4a05f17bc222485e11f8"
    sha256 arm64_sonoma:  "906bb05c2f545c05d01bad4b2586062eb1b20ad8bad282764c0f7a92854bd8d7"
    sha256 arm64_ventura: "33a578ee475d93df011511e55401bcbc0ab088be992adfacadc15b0a52d243c7"
    sha256 sonoma:        "3754ae61604fdf599d180ecafbaacb9556c20ece3648517fc073c34347fabe8c"
    sha256 ventura:       "bfc24629df2761c9f36568977ab0e014e0b4ca15fad604c4bb2e7c3649d36433"
    sha256 arm64_linux:   "68202f26b1e5f3f2e4078dcc5e023c6bf3085104fbf7a2a130db248bc44a8400"
    sha256 x86_64_linux:  "eeb0cacef3dfec5b0d843289cf7fa34b96d08f569e5ac820a796c9109ed3c12a"
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

