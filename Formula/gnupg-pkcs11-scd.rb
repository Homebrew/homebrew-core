class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.9.0/gnupg-pkcs11-scd-0.9.0.tar.bz2"
  sha256 "8f9a2b56ef9c1ae0f6c9146cc842c05a8b77da5be2548b1c92bd555c5e868814"

  bottle do
    cellar :any
    sha256 "3b41d4df2c52d4617316e4a34f803b4682c46d1138a6a13e8fda3912cb1dec5a" => :sierra
    sha256 "932defd40d09b9c69c4eba55136d03fba708ec7eb078c4e0c3ec044e26169352" => :el_capitan
    sha256 "ea494eb88c5cf518b1bd7e4190f81b20ba9cd29256137a8b2cb7bbe0524b0a52" => :yosemite
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
