class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://directory.fsf.org/wiki/Libgcrypt"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.3.tar.bz2"
  sha256 "66ec90be036747602f2b48f98312361a9180c97c68a690a5f376fa0f67d0af7c"

  bottle do
    cellar :any
    sha256 "b77455dffe35f08fb22d4aa9aae70e68bb3a697b024f57dc4dff8c9b86cecb63" => :high_sierra
    sha256 "e10cc6cc1659cc9af6b165ce1e9c380f0f2b749a687fc221fb81494fee0ba579" => :sierra
    sha256 "fb844b8e5f22c9617bd50685349dfddd234c715ca2cf555675d181bf207b2ef7" => :el_capitan
  end

  depends_on "libgpg-error"

  def install
    # Temporary hack to get libgcrypt building on macOS 10.12 and 10.11 with XCode 8.
    # Seems to be a Clang issue rather than an upstream one, so
    # keep checking whether or not this is necessary.
    # Should be reported to GnuPG if still an issue when near stable.
    # https://github.com/Homebrew/homebrew-core/issues/1957
    ENV.O1 if DevelopmentTools.clang_build_version == 800

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--disable-jent-support" # Requires ENV.O0, which is unpleasant.

    # Parallel builds work, but only when run as separate steps
    system "make"
    # Slightly hideous hack to help `make check` work in
    # normal place on >10.10 where SIP is enabled.
    # https://github.com/Homebrew/homebrew-core/pull/3004
    # https://bugs.gnupg.org/gnupg/issue2056
    MachO::Tools.change_install_name("#{buildpath}/tests/.libs/random",
                                     "#{lib}/libgcrypt.20.dylib",
                                     "#{buildpath}/src/.libs/libgcrypt.20.dylib")

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
