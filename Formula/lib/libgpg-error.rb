class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.50.tar.bz2"
  sha256 "69405349e0a633e444a28c5b35ce8f14484684518a508dc48a089992fe93e20a"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "bd6a0df1e2dc2a571fd5b6301bc52b60c0406fbb6eec9a819ff191c0c8873c5b"
    sha256 arm64_sonoma:   "ca69e2f2ede55c1ec6ca0775514d8fcf1325929c2075cba5ce6f13c7beb48ee6"
    sha256 arm64_ventura:  "39a574d760ce7edb87090cd0d40496dbdb44c54937e92aabdca28dacff160034"
    sha256 arm64_monterey: "6669e9645a1d9469e2b9e51905d8294e6fab2aca452f00044da8d226146f58f2"
    sha256 sonoma:         "842bb37e5e6354e8c9b9a023abcd7f81c3d752adaccc74e5f8e393290c321cc9"
    sha256 ventura:        "3539b7806b7dbcadaf1fbbce13601766ef509c53a8efbbfc09ab7ff4d8b9fb49"
    sha256 monterey:       "91e502d42e3f42a5c3c5bf8d5dbb326bea645fce31113805a45a6f84491d1758"
    sha256 x86_64_linux:   "c242b00ecb9d4d2e98604bfba093161f6f275322cb015d83c5b28d51caf0a26d"
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

