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
    sha256 cellar: :any,                 arm64_monterey: "814ad8451d7a20b03590289dcea6232d17412ffb910886fc8ae8b903de4c38b3"
    sha256 cellar: :any,                 arm64_big_sur:  "9421cc3b2166199f598f523123048e28001d20fe549e15be4f8ff68672ca34c2"
    sha256 cellar: :any,                 monterey:       "a85e017efead8890447ef3dd82a0d5abdcb4ac1d55c67ac11ec4fc8b955258a8"
    sha256 cellar: :any,                 big_sur:        "f41a416b42273557a1747c89b936160147bba984edf90d05dcdd90977255c4b2"
    sha256 cellar: :any,                 catalina:       "744c2e13d08b46aceba533ff905cf61eebf84030e81146db3eb708a226709227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "938afdcee08b2d6e0cd1b5c4b125c1ff693848e0adc621283b4f3486ad2b54a4"
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
