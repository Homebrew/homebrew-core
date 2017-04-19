class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.7.6/gnupg-pkcs11-scd-0.7.6.tar.bz2"
  sha256 "2962dc39a80c5aa9e71f0b847de8f66a9f02b620696d213bb138c17ffec9f7af"

  bottle do
    cellar :any
    sha256 "76fe29258ec0b931a468d7f0333eeee6db03ef6fa440cdf8a222b3cb9775403f" => :sierra
    sha256 "7ab95867800f969ae1c45637a55d66c61f5671aed35413d3c5519d24fd7cc385" => :el_capitan
    sha256 "cc2788faa88ecb33a0bbb5ffe58e466d98ab588a2074293df6b71b5d0f37287b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "pkcs11-helper"

  def install
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
