class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.9.1/gnupg-pkcs11-scd-0.9.1.tar.bz2"
  sha256 "abd3d13eb889c3793da319ddedd0f9b688572abb51b050d8284d1b44dfca94a9"

  bottle do
    cellar :any
    sha256 "ce2127047e7bb4f07cdc7702fa399d2c357eac20a8b9b2b7fa879908b836257a" => :mojave
    sha256 "b1b94851685ebb8dc920e4e5212c2b7effa2e831f184d8b8e66e44b1c9630d93" => :high_sierra
    sha256 "eccf8f2df5f2007142529fd3b34085ef3f81500173dc6fccd0a94dfe76c7ad19" => :sierra
    sha256 "0b236bc743da30e0db9458d55a1e511c792d9ed85c97c726a87b5932e8a21dc7" => :el_capitan
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
