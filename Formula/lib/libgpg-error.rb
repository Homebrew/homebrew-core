class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.54.tar.bz2"
  sha256 "607dcadfd722120188eca5cd07193158b9dd906b578a557817ec779bd5e16d0e"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1686756cb615fd9923294454f6b2e125ae7d8941124af4c5a9006e07b93c99a9"
    sha256 arm64_sonoma:  "f9d9f01c1f09ad6634937e17e19cca4339f149cbcdb5b5950836f6df2b3b90aa"
    sha256 arm64_ventura: "f008ae12c2ab5a54816c701f9b265882651b11a910607263aa4defd9c94b72a0"
    sha256 sonoma:        "d6c2ac6208c1105ea6e19e53a02c0029b347aaea6174722cd74b8f4872df9bb4"
    sha256 ventura:       "909700c857d88f104db1e08fe6d04cc68ed9bd024665b3173b5596c0d0b4617f"
    sha256 arm64_linux:   "74246d7062ad4198b31b6f8e2118cdfdcacd274053eff1a55ce5509d7fbc0abc"
    sha256 x86_64_linux:  "6ccfffa57cde32e9e6a61647fbc6397727412bb0830b6549db17433e046802b1"
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

