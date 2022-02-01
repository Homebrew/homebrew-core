class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.0.tar.bz2"
  sha256 "6a00f5c05caa4c4acc120c46b63857da0d4ff61dc4b4b03933fa8d46013fae81"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "db8ca3ac372b23c25be44950acae40a4bb8faa4312df72023a28959a09cd8ea7"
    sha256 cellar: :any,                 arm64_big_sur:  "ebe24d93edccd91ac094387b74b0c42aeebd44a6bb5f583816c8d1690690cf57"
    sha256 cellar: :any,                 monterey:       "b8b834ecc967d71931b73f4102ef74be06812358def29cf37700ae1d57494c80"
    sha256 cellar: :any,                 big_sur:        "19f11700630c036864c3acaf39d6b26b8d7f46a96b7eab4cab5d118ce5a0c28a"
    sha256 cellar: :any,                 catalina:       "22b69fca91210d5598644b6164980ea3d53ccbb9a66124314ae3836b9100a4bf"
    sha256 cellar: :any,                 mojave:         "d40e101e9605d7ba2b56fa6c441565192a85b3bb67302ab4feeac4d38a56d261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c199805c55e5f11d84e19554b3583d78a2e681a0ba549508927c2528d07372cd"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}"

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "make", "-C", "random", "rndjent.o", "rndjent.lo" }

    # Parallel builds work, but only when run as separate steps
    system "make"
    MachO.codesign!("#{buildpath}/tests/.libs/random") if OS.mac? && Hardware::CPU.arm?

    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libgcrypt-config", prefix, opt_prefix
  end

  test do
    touch "testing"
    output = shell_output("#{bin}/hmac256 \"testing\" testing")
    assert_match "0e824ce7c056c82ba63cc40cffa60d3195b5bb5feccc999a47724cc19211aef6", output
  end
end
