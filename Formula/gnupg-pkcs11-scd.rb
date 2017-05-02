class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.7.6/gnupg-pkcs11-scd-0.7.6.tar.bz2"
  sha256 "2962dc39a80c5aa9e71f0b847de8f66a9f02b620696d213bb138c17ffec9f7af"

  bottle do
    cellar :any
    sha256 "038f17f2991af6a5dff4b951e6626db731c7028604df7d39ea1e81b488c33cfe" => :sierra
    sha256 "61573ec6f827dc0743a4929d0516fea8ed2ed96a4eef541274769d67298e415e" => :el_capitan
    sha256 "8188dd42d4251fc2a9f381d4c476c47a10a84315717e2c312a851cece85e648a" => :yosemite
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
