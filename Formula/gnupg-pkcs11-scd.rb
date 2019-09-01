class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.9.2/gnupg-pkcs11-scd-0.9.2.tar.bz2"
  sha256 "fddd798f8b5f9f960d2a7f6961b00ef7b49b00e8bf069c113a4d42b5e44fd0d5"
  revision 1

  bottle do
    cellar :any
    sha256 "78537d1ee3285a604aae1d683db56da1b9ec76bf71262ff234e758efda63f885" => :mojave
    sha256 "1f4264ac76b36c453a3c5a000d1b1269f331e88420efc5591274ccbb8dc8b85c" => :high_sierra
    sha256 "83748a14d87233e8a2cf4744d0353c01176536b5cd9e1b317f741f824416453f" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pkcs11-helper"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--with-libassuan-prefix=#{Formula["libassuan"].opt_prefix}",
                          "--with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/gnupg-pkcs11-scd", "--help"
  end
end
