class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.9.2/gnupg-pkcs11-scd-0.9.2.tar.bz2"
  sha256 "fddd798f8b5f9f960d2a7f6961b00ef7b49b00e8bf069c113a4d42b5e44fd0d5"
  revision 1

  bottle do
    cellar :any
    sha256 "99a4910d7fc7e0a7a101b66f4634aef44d61233327b720eef13612fef9406f22" => :mojave
    sha256 "a226b2072da2340d2acda61cfd0e4be867d90646fe4a0d5816ff0f4c593907b0" => :high_sierra
    sha256 "28a6407547621148fcb957b4c16da177e8a346383b0102ee7352650672b44021" => :sierra
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
