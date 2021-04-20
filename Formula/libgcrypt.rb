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
    sha256 cellar: :any, arm64_big_sur: "65279a10d89457614d2302e2d89fed3c1fa9cdc69a8fe7c2f4c4d48d6d375def"
    sha256 cellar: :any, big_sur:       "54c3d59311aea6eff9d5a313243d5dd037f17d936a14e3fe707828f4e06de389"
    sha256 cellar: :any, catalina:      "7b62e5158ca2910802dbd6a478bac6679b1a967ec7739a80018ae0069fcb2468"
    sha256 cellar: :any, mojave:        "dcd2fb732dcf01ba32dea8f5e0d739ccfdd39ed2734520c985c73dff81b8cb8c"
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
