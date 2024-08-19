class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.net/"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.10.0/gnupg-pkcs11-scd-0.10.0.tar.bz2"
  sha256 "29bf29e7780f921c6d3a11f608e2b0483c1bb510c5afa8473090249dd57c5249"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/gnupg-pkcs11-scd[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6b5af03aeaefa6524219a48594b4f3dece1d93b92630378ba8aad1242ca7c193"
    sha256 cellar: :any,                 arm64_ventura:  "f1daa25116f084c286b8b3b1924037cbe1e98825886e483a1dc182bfe41741f0"
    sha256 cellar: :any,                 arm64_monterey: "a8e536a7832c5c2c49e7450db536f28541ffd4a20de15115235e32620fc8b9c5"
    sha256 cellar: :any,                 sonoma:         "21483efa80f641f55c1496e5ce9078577667c3fc3ee31ef681a2b72e720f8e45"
    sha256 cellar: :any,                 ventura:        "fe744f6d2f5e2ab44544048011f36916072eefecb5a30150bc34747aea033e17"
    sha256 cellar: :any,                 monterey:       "2dfbe4f94da6fffb6365b03f06bc81abf28016adb4b08519a6794b619cadec71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7610c2def9c9575bac8b8433ad4ec55f66d40ff82f724c805ce37e9a3ad8c9a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libassuan@2"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--with-libassuan-prefix=#{Formula["libassuan@2"].opt_prefix}",
                          "--with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"gnupg-pkcs11-scd", "--help"
  end
end
