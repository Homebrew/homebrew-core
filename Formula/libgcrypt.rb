class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://directory.fsf.org/wiki/Libgcrypt"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.7.2.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.7.2.tar.bz2"
  sha256 "3d35df906d6eab354504c05d749a9b021944cb29ff5f65c8ef9c3dd5f7b6689f"
  revision 1

  bottle do
    cellar :any
    sha256 "506dba4480759340c8086178ad7c82a27ab0388c7ff679a1f53c742c271acffa" => :el_capitan
    sha256 "4cc2302042335a0c2e849b200f8410e8dc5c3ee4a51fc705c1b03853d6215a92" => :yosemite
    sha256 "d18641e490bf7c7e7b158aab67ae2e5dc84383c3e436d436864f7500bf842b2c" => :mavericks
  end

  option :universal

  depends_on "libgpg-error"

  resource "config.h.ed" do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec8d133/libgcrypt/config.h.ed"
    version "113198"
    sha256 "d02340651b18090f3df9eed47a4d84bed703103131378e1e493c26d7d0c7aab1"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}"

    if build.universal?
      buildpath.install resource("config.h.ed")
      system "ed -s - config.h <config.h.ed"
    end

    # Parallel builds work, but only when run as separate steps
    system "make"
    # Slightly hideous hack to help `make check` work in
    # normal place on >10.10 where SIP is enabled.
    # https://github.com/Homebrew/homebrew-core/pull/3004
    # https://bugs.gnupg.org/gnupg/issue2056
    system "install_name_tool", "-change",
                                lib/"libgcrypt.20.dylib",
                                buildpath/"src/.libs/libgcrypt.20.dylib",
                                buildpath/"tests/.libs/random"
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
