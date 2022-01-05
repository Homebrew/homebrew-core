class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.io"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.10.0/gnupg-pkcs11-scd-0.10.0.tar.bz2"
  sha256 "29bf29e7780f921c6d3a11f608e2b0483c1bb510c5afa8473090249dd57c5249"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/gnupg-pkcs11-scd[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c783d038482db57a2d8d2c6752db239b851cd4efdbcd246dcb5be6d72809621f"
    sha256 cellar: :any,                 arm64_big_sur:  "c66622684e3b7200502f7f900c89db167e86b1886d3ac0f55868af58cb4d7b10"
    sha256 cellar: :any,                 monterey:       "515f27e4a0f27055fb2f7baab59ef6ec5aae2853e63c3b15f5ec641f994e4022"
    sha256 cellar: :any,                 big_sur:        "f14a431b4b3a20f193d279afd4aaaba3700af4c1d9cb059ed06e9469f2eb6812"
    sha256 cellar: :any,                 catalina:       "728f08c91b4137c0472594d0e53ea171e808ab90376b3a8c2e1f9cd65eff452f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63e019746caec337a340e65ce8fa26a1d02a07837777fa65e863d1e6c51d5de2"
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
