class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://directory.fsf.org/wiki/Libgcrypt"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.2.tar.bz2"
  sha256 "c8064cae7558144b13ef0eb87093412380efa16c4ee30ad12ecb54886a524c07"

  bottle do
    cellar :any
    sha256 "953d240fb5ad214115771e6d39b423aebc065c0176b79e086487b88042f87164" => :high_sierra
    sha256 "e7528cc28b8287e0498a92b269b3148435dcb08b3012974a0ca3883b8e959a53" => :sierra
    sha256 "8bfa6159d5615cfca50ca7a2ef1bb5990f79a91f230b853d861f6ed356e1ac63" => :el_capitan
    sha256 "141c42f7f8e2298d504e6cc99d8b087ed698146fcb8be304a60b9f3d0409787a" => :yosemite
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
