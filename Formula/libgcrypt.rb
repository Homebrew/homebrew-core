class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://directory.fsf.org/wiki/Libgcrypt"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.8.0.tar.bz2"
  sha256 "23e49697b87cc4173b03b4757c8df4314e3149058fa18bdc4f82098f103d891b"

  bottle do
    cellar :any
    sha256 "83c46c8bcf7fbaee2ba7140179fc1f4965af5fca38873df7e8d0c61b214da89e" => :sierra
    sha256 "1a3d9d442fcee318295902030c35ffcd4c6bcf61f749cc51485e52e0e68887d3" => :el_capitan
    sha256 "eaf1961e564e530619a0ae87094a4a40210d054bb9826fceb8e611562916adfe" => :yosemite
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
