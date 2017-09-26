class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.9.1/gnupg-pkcs11-scd-0.9.1.tar.bz2"
  sha256 "abd3d13eb889c3793da319ddedd0f9b688572abb51b050d8284d1b44dfca94a9"

  bottle do
    cellar :any
    sha256 "74a757b255ac7eddf9fd786c2ae817d8ffcc9dba00db4d3fc8699ade1f63cba3" => :high_sierra
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
