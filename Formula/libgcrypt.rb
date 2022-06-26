class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.1.tar.bz2"
  sha256 "ef14ae546b0084cd84259f61a55e07a38c3b53afc0f546bffcef2f01baffe9de"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3fe47336e43abb2d06395af3ddb83aceb9a08b826f338d2f740eb57271f1eddc"
    sha256 cellar: :any,                 arm64_big_sur:  "3350e668f3ff1a912cb16c74104eb835134fe0343bea9db4d6bf027f24616593"
    sha256 cellar: :any,                 monterey:       "ac2f757bc87dac1c676d14d4382aa3baa1b3dadc3850aedd99b6acd8c06e4719"
    sha256 cellar: :any,                 big_sur:        "e3c2dfd3c1a92117d52ca06de3e05f427c7c045031957cd61ebbf0e8146c7052"
    sha256 cellar: :any,                 catalina:       "39658feb6872c97f486ea8c88cd515411a612baf459721f4b88196067fb91ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff2a2b4cf7e623f895acb2cec5a85c5878d1db618637eb8495e2f6850ab21ed"
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
