class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.7.5/gnupg-pkcs11-scd-0.7.5.tar.bz2"
  sha256 "80ee610c0c798d2da887a22d5614366f4d9e06f296377dcf7e4fd59c2c1eb15e"

  bottle do
    cellar :any
    sha256 "720587bc6d99e67f4ed5a1e0a966a5e79dd4246b02439d8e9c5f1d39cbe9b131" => :sierra
    sha256 "20bf6e1bd39c9d664365e7179b5add79a4f1c5ab8a66d18ad4abd6e4c74cebbf" => :el_capitan
    sha256 "8a0d9351dea28bef9f0ede96fe8777b6dd0f483ab58fd96e57467dbb255f72e7" => :yosemite
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
