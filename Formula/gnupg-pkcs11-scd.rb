class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.9.0/gnupg-pkcs11-scd-0.9.0.tar.bz2"
  sha256 "8f9a2b56ef9c1ae0f6c9146cc842c05a8b77da5be2548b1c92bd555c5e868814"

  bottle do
    cellar :any
    sha256 "022b3b56d9bbb25bdd95e91a9cd092a15d130dd68d5566a7aea982791f926b38" => :sierra
    sha256 "2cc28c1eb5a9a400a0bd28ccf7f9b2886c3949f351762a82cf57e7a30a3b64da" => :el_capitan
    sha256 "6bf4094eb3e6fc940aecc773813d5ae990e6e61eec937044724fb293f7185cc2" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "pkcs11-helper"

  # Remove for > 0.9.0
  # Fix "incomplete type 'struct ucred' and undeclared identifier 'SO_PEERCRED'"
  # Reported 26 Aug 2017 https://github.com/alonbl/gnupg-pkcs11-scd/issues/8
  patch do
    url "https://github.com/alonbl/gnupg-pkcs11-scd/pull/9.patch?full_index=1"
    sha256 "d4a2d37e9d54eefd69244422ff8bfffc98b43816a2e24ea8b59b8cb1b04d7195"
  end

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
