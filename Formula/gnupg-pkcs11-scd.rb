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
    sha256 cellar: :any,                 arm64_ventura:  "ff2df0d0d0b140aecb03f1828c7a2cbdf1fe1752e51b6443e16c11bed5685dee"
    sha256 cellar: :any,                 arm64_monterey: "6a9e558c32ca0a72baba7945d2a883132adea17654befea53138c7a057add793"
    sha256 cellar: :any,                 arm64_big_sur:  "1c3702b21e91a23530aa6e16807c748151433312f38ebeb6a7944a654ee57bb4"
    sha256 cellar: :any,                 ventura:        "19fd7386008289f8d354d958dd40554a496d5e7e2dbc75ea2586cf093cb7657f"
    sha256 cellar: :any,                 monterey:       "f79ae4cbac8bda88dc0902fe2a36ace5ecc961a5bbcd88187127d3eb3484d4e5"
    sha256 cellar: :any,                 big_sur:        "0019a8eac93fa627cf2ee05d66409042386e65d0462aaf2225d048ce6ad792d2"
    sha256 cellar: :any,                 catalina:       "fa6b2bfb9afff54c8e32072413513e293d6f53012c0f225794711d81aeca1ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4252b9d56d7a919df5f59ddcf3cb31f7b1694e703d310552bb8f3218d0bd5d8a"
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
