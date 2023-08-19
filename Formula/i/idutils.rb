class Idutils < Formula
  desc "ID database and query tools"
  homepage "https://www.gnu.org/s/idutils/"
  url "https://ftp.gnu.org/gnu/idutils/idutils-4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/idutils/idutils-4.6.tar.xz"
  sha256 "8181f43a4fb62f6f0ccf3b84dbe9bec71ecabd6dfdcf49c6b5584521c888aac2"
  license "GPL-3.0"
  revision 1

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "c410f473b777ac344a863267348be1dc14f587c28f6c3a5845cc556ce52ba843"
    sha256 arm64_monterey: "072b4846a5c749954544e7b747d2951d4ee43a4bd6f024e817ac74743cdeefa7"
    sha256 arm64_big_sur:  "321fd582b7e17f7f912f76f0b5e8f57d16ebf9ea6c8721854c2567df8136fe28"
    sha256 ventura:        "1d29ee25c018fa81e5cc297091cb8190fa0dbdb54c2ad21c8909cff989e8703c"
    sha256 monterey:       "e3fc421fedb08ac46a82fb2dd8127f4c7c03c6103d943b53a49e8220406ed157"
    sha256 big_sur:        "4e20dbb5fa6efb604aba5c3fab7b2fe948517c16569a3c27fa5b314e0d0730bf"
    sha256 catalina:       "7e27c7bad2b5d30c4ee26ffb21cf0412706e83c17d0d55b7cefd1f63c919063c"
    sha256 x86_64_linux:   "54a8af17aba2695b61bd976d6ae4bf2f13c45cec787b1c14b497080d5bac9ce9"
  end

  conflicts_with "coreutils", because: "both install `gid` and `gid.1`"

  patch :p0 do
    on_high_sierra :or_newer do
      url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  # Fix build on Linux. Upstream issue:
  # https://savannah.gnu.org/bugs/?57429
  # Patch submitted here:
  # https://savannah.gnu.org/patch/index.php?10240
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    system bin/"mkid", "#{MacOS.sdk_path}/usr/include"
    system bin/"lid", "FILE"
  end
end

__END__
diff --git a/lib/stdio.in.h b/lib/stdio.in.h
index 0481930..79720e0 100644
--- a/lib/stdio.in.h
+++ b/lib/stdio.in.h
@@ -715,7 +715,6 @@ _GL_CXXALIASWARN (gets);
 /* It is very rare that the developer ever has full control of stdin,
    so any use of gets warrants an unconditional warning.  Assume it is
    always declared, since it is required by C89.  */
-_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
 #endif
