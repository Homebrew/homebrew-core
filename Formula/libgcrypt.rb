class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://directory.fsf.org/wiki/Libgcrypt"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.7.8.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.7.8.tar.bz2"
  sha256 "948276ea47e6ba0244f36a17b51dcdd52cfd1e664b0a1ac3bc82134fb6cec199"

  bottle do
    cellar :any
    sha256 "3ee390e97f01b7c76598e792e70535a36f6ef8c7c17aaa53da2e85d58f8a3247" => :sierra
    sha256 "56f8d744f774ba092ffd329221284f7cdbfbba737020a184e9836ab7b8f94ba3" => :el_capitan
    sha256 "b72790d88a631f9d524dc2bc4604360d2bbbac8a95fe0553bef88ad070ddec82" => :yosemite
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
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}"

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
