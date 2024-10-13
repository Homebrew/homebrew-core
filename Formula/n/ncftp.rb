class Ncftp < Formula
  desc "FTP client with an advanced user interface"
  homepage "https://www.ncftp.com/"
  url "https://www.ncftp.com/public_ftp/ncftp/ncftp-3.2.7-src.tar.xz"
  mirror "https://fossies.org/linux/misc/ncftp-3.2.7-src.tar.xz"
  sha256 "d41c5c4d6614a8eae2ed4e4d7ada6b6d3afcc9fb65a4ed9b8711344bef24f7e8"
  license "ClArtistic"

  livecheck do
    url "https://www.ncftp.com/download/"
    regex(/href=.*?ncftp[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "d83a44de643f84beafe658ac72254cc4076969ba0d21af37fcb8657e5e111009"
    sha256 arm64_sonoma:   "d19dfe3a0904aed345087215372912f60d56b9d4d45d0ecb3a53d56df63f7b08"
    sha256 arm64_ventura:  "bf0baa98f6a3d4f479fa472bc07e0fc1b30e1e52ee74033e6512546b10ffa167"
    sha256 arm64_monterey: "b04b6ca30d0613e686747b504c398c9379f50a8d3ccf0f2164e515a78387e44f"
    sha256 sonoma:         "ef11591a8ac1d0da3730428ad875f2b3c0e562b294384bd957dd62483107d26c"
    sha256 ventura:        "99349738380dad087e367e45a51ccc0e691b48f6685117946cf7ab9f20240ed9"
    sha256 monterey:       "249376244141988531b03e7ce0346f0f680ec316ff4aee37888760927451623b"
    sha256 x86_64_linux:   "21cf1eb7c37bd26452cb6749fcded064471432468eb1afeaf17e5355aee8503f"
  end

  uses_from_macos "ncurses"

  # fix conflicting types for macos build, sent the patch to support@ncftp.com
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--disable-universal",
                          "--disable-precomp",
                          "--with-ncurses",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ncftp", "-F"
  end
end

__END__
diff --git a/sio/DNSUtil.c b/sio/DNSUtil.c
index 0d542bb..eb7e867 100644
--- a/sio/DNSUtil.c
+++ b/sio/DNSUtil.c
@@ -12,7 +12,7 @@
 #	define Strncpy(a,b,s) strncpy(a, b, s); a[s - 1] = '\0'
 #endif

-#if (((defined(MACOSX)) && (MACOSX < 10300)) || (defined(AIX) && (AIX < 430)) || (defined(DIGITAL_UNIX)) || (defined(SOLARIS)) || (defined(SCO)) || (defined(HPUX)))
+#if ((defined(AIX) && (AIX < 430)) || (defined(DIGITAL_UNIX)) || (defined(SOLARIS)) || (defined(SCO)) || (defined(HPUX)))
 extern int getdomainname(char *name, gethostname_size_t namelen);
 #endif
