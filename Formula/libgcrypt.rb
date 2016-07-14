class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://directory.fsf.org/wiki/Libgcrypt"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.7.2.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.7.2.tar.bz2"
  sha256 "3d35df906d6eab354504c05d749a9b021944cb29ff5f65c8ef9c3dd5f7b6689f"

  bottle do
    cellar :any
    sha256 "94b6b3a485de8058ead4f6d18bd383b3618f61918c5f9e34f617b019ad0f16d8" => :el_capitan
    sha256 "86e5475d3adcca875723f6ff552759812d0a0565f66e1acdd957009b0d0ff300" => :yosemite
    sha256 "80610d469a9165e1fcdd413c95e6b97a272e65dcf5c6d3a68afbd171b51e4246" => :mavericks
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
  end

  test do
    touch "testing"
    output = shell_output("#{bin}/hmac256 \"testing\" testing")
    assert_match "0e824ce7c056c82ba63cc40cffa60d3195b5bb5feccc999a47724cc19211aef6", output
  end
end
