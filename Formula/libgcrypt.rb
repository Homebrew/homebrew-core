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
    sha256 cellar: :any,                 arm64_big_sur: "17c61d873adf2bd5aec0858dadeeacdf75ac1f9cce3d7acbd4d0b5c43a191f98"
    sha256 cellar: :any,                 big_sur:       "c8c50af567c82a2c68f657b4ee3422bee39944c819a939d18b73617d8e5c0476"
    sha256 cellar: :any,                 catalina:      "6393017fddac1c337f49fc066e5a900bfac896c94a6a0aaa73acd349a757b924"
    sha256 cellar: :any,                 mojave:        "0c54acef4c1fe000909441cd946f60bebe636fc232edff73a88bbb9df2b10447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963a50f5a822f6edbdf8e22d07a2b10349223a60143343ae9a32a9f1b65ee8a9"
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
