class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.6.tar.bz2"
  sha256 "0cba2700617b99fc33864a0c16b1fa7fdf9781d9ed3509f5d767178e5fd7b975"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "bc8f0fdc3dccd598c6bc332e6e2f7add94812bef84db722e878c5a85dcf43565" => :catalina
    sha256 "a019ef3d51d67a318557b15745552d59315e20ebbae74c39bac3588932869260" => :mojave
    sha256 "142003e0e2f01c607e2f1a7c132c0db4612aa758d7a038e06f64910b0dcfa1a3" => :high_sierra
  end

  depends_on "libgpg-error"

  uses_from_macos "libxslt"

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
