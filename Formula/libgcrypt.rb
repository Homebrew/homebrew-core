class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.9.4.tar.bz2"
  sha256 "ea849c83a72454e3ed4267697e8ca03390aee972ab421e7df69dfe42b65caaf7"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7ac0af3e86d07de27a266a4af024f884766b648cbbb7401b64ed284c2c5335f2"
    sha256 cellar: :any,                 big_sur:       "20ad92478a6775e5f7a1eb47a5313acdd70f3ffd42bf8aef0e34ef525253f265"
    sha256 cellar: :any,                 catalina:      "8f532353249ed8c616a9c8708ea1d050ba9b1cdc50e2aeaa374b94ddef184350"
    sha256 cellar: :any,                 mojave:        "3cd2ad75c176919c00c7d49c9bcedbdcea319d9a09454df1a314680fd4f946a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a987d3b3397bc43404723e180fa5832273dc8bfc23087e6016de5a602fc8fb33"
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
    on_macos do
      MachO.codesign!("#{buildpath}/tests/.libs/random") if Hardware::CPU.arm?
    end

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
