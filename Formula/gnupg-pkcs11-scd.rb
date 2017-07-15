class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.8.0/gnupg-pkcs11-scd-0.8.0.tar.bz2"
  sha256 "391d16c1a8c9a4771963b72fca04becdf8953a3223e23db738a4c94c62beb834"

  bottle do
    cellar :any
    sha256 "022b3b56d9bbb25bdd95e91a9cd092a15d130dd68d5566a7aea982791f926b38" => :sierra
    sha256 "2cc28c1eb5a9a400a0bd28ccf7f9b2886c3949f351762a82cf57e7a30a3b64da" => :el_capitan
    sha256 "6bf4094eb3e6fc940aecc773813d5ae990e6e61eec937044724fb293f7185cc2" => :yosemite
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
