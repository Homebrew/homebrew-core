class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.net/"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.10.0/gnupg-pkcs11-scd-0.10.0.tar.bz2"
  sha256 "29bf29e7780f921c6d3a11f608e2b0483c1bb510c5afa8473090249dd57c5249"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/gnupg-pkcs11-scd[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "306ec3bbfc7f29c826c071461af2585f0759bab3e49c11aaa42181f0950ab8ab"
    sha256 cellar: :any,                 arm64_sonoma:  "554ec82459c766488cfa01e5a2ac16b9c576badba3848ae5d2f90b89e2dadabb"
    sha256 cellar: :any,                 arm64_ventura: "e4d76440af9ca88fe628307bcef9a9313ad8ae2d07c40ed3367fa82e8c386b7b"
    sha256 cellar: :any,                 sonoma:        "271520fe7493472155570298cb379f0f08da53a7de947e448e5c499e3fe680b5"
    sha256 cellar: :any,                 ventura:       "3e9b548b5a804619036a14524f563fc360846826868f700ac08057d3ddd68784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0635d9f5f524a8de9291d9608fe4eee289f973156f2d6e10dd58e4edefe7481"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"

  # Backport pkg-config usage to support newer `libassuan`
  patch :DATA
  patch do
    url "https://github.com/alonbl/gnupg-pkcs11-scd/commit/de08969ae92d31b585d7055eb0734962f55a7282.patch?full_index=1"
    sha256 "591833296a6e7401732f2ea104004d1dc57567ea2b661a2a1688bcd8e1f7fed8"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"gnupg-pkcs11-scd", "--help"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 816ab5b..5ec9323 100644
--- a/configure.ac
+++ b/configure.ac
@@ -168,21 +168,21 @@ AC_ARG_WITH(

 AC_ARG_WITH(
 	[libgpg-error-prefix],
-	[AC_HELP_STRING([--with-libgpg-error-prefix=DIR], [define libgpgp-error prefix])],
+	[AS_HELP_STRING([--with-libgpg-error-prefix=DIR], [define libgpgp-error prefix])],
 	,
 	[with_libgpg_error_prefix="/usr" ]
 )

 AC_ARG_WITH(
 	[libassuan-prefix],
-	[AC_HELP_STRING([--with-libassuan-prefix=DIR], [define libassuan prefix])],
+	[AS_HELP_STRING([--with-libassuan-prefix=DIR], [define libassuan prefix])],
 	,
 	[with_libassuan_prefix="/usr" ]
 )

 AC_ARG_WITH(
 	[libgcrypt-prefix],
-	[AC_HELP_STRING([--with-libgcrypt-prefix=DIR], [define libgcrypt prefix])],
+	[AS_HELP_STRING([--with-libgcrypt-prefix=DIR], [define libgcrypt prefix])],
 	,
 	[with_libgcrypt_prefix="/usr" ]
 )
