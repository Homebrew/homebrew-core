class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.9.3.tar.bz2"
  sha256 "97ebe4f94e2f7e35b752194ce15a0f3c66324e0ff6af26659bbfb5ff2ec328fd"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "6ff63025955ee85e6ff10b955f32b1c583439860ad72da5d88acc60b1c9ecc73"
    sha256 cellar: :any, big_sur:       "1848ca1e79f8c4315ba761eb4ad1022d237d6701d47a207130b09093d99f24ef"
    sha256 cellar: :any, catalina:      "91ec702c7907c1ddd20998ff35299a63ac6108cb4f9a76df1c368a4c49da4a90"
    sha256 cellar: :any, mojave:        "6a8fa532b2c12d89f2becc1a84e9b5d07fef25a080a607f2d7b341eea5e6081b"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--disable-jent-support" # Requires ENV.O0, which is unpleasant.

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
