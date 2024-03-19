class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.net/"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.10.0/gnupg-pkcs11-scd-0.10.0.tar.bz2"
  sha256 "29bf29e7780f921c6d3a11f608e2b0483c1bb510c5afa8473090249dd57c5249"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gnupg-pkcs11-scd[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b109d8b331ed54697a9c26bf3af0e2ba6ac6611bc3fa43797c725f2005e4fefa"
    sha256 cellar: :any,                 arm64_ventura:  "637d2da5209f612c115bfebe4cf6d3e5d1941c4498c077461091672ade772b45"
    sha256 cellar: :any,                 arm64_monterey: "3c669ce77d7e6e31b830b1eaaab48b00ffda6d0c95151acf532b8f73407e9e04"
    sha256 cellar: :any,                 arm64_big_sur:  "32861ea6eb6c72179d05684171a4ca32ce177d62deb4e1abeb7f47f7656fb54f"
    sha256 cellar: :any,                 sonoma:         "ae9fcd61be5bafa086ed506880b470ff50040c3c278e3e64ea455f52dae8dc28"
    sha256 cellar: :any,                 ventura:        "7883e6d5438dfecc6ec1e3d10b7afd8927f15cf8bad9760105cb2f2ec8606047"
    sha256 cellar: :any,                 monterey:       "47c89528a70ed380c30748379e4a996e3081371e3140ae694ab98ac679e66a1f"
    sha256 cellar: :any,                 big_sur:        "51530e19934fdb181f1f21f9c453cf234381bcaad2ea0626a77a5865ac68878c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1426c349e8f781f2ef03b2cc965e2ff9a12784c5416e3fcc34ab50902afb14"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@3"
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
