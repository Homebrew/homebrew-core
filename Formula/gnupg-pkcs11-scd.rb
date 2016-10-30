class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "http://gnupg-pkcs11.sourceforge.net"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/archive/gnupg-pkcs11-scd-0.7.3.tar.gz"
  sha256 "69412cf0a71778026dd9a8adc5276b43e54dc698d12ca36f7f6969d1a76330b8"
  revision 2

  head "https://github.com/alonbl/gnupg-pkcs11-scd.git"

  bottle do
    cellar :any
    sha256 "2c7a6a77a0ef21444e301811a1b030f26a55606d682baa19918bd8b56f2acca9" => :sierra
    sha256 "50f2025059f91cdf5c316d96b4e52d52414c56fe6d986f2a9cafb8fbb41ea306" => :el_capitan
    sha256 "cb40786fe9903329fc542a638f96bc7a7a40a5f7edae7b632bb667acb9cc6e89" => :yosemite
    sha256 "534831eb894e729bf231892c974305d0e70763179a105ba5b9babb43756ee5ba" => :mavericks
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
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--with-libassuan-prefix=#{Formula["libassuan"].opt_prefix}",
                          "--with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gnupg-pkcs11-scd --help > /dev/null ; [ $? -eq 1 ]"
  end
end
