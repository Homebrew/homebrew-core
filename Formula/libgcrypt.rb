class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.7.tar.bz2"
  sha256 "03b70f028299561b7034b8966d7dd77ef16ed139c43440925fe8782561974748"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/libgcrypt[._-]v?(\d+\.\d+\.\d+)/i)
  end

  bottle do
    cellar :any
    sha256 "04469a9f2058b744d182ce1ea66196150f6a9210997a459fb061b608d133c05d" => :big_sur
    sha256 "4a85ffff9102745d1261cf252482bc9b19adc8b555885561f000894b04d828d3" => :arm64_big_sur
    sha256 "b736ce71bf9af64a1b3adee264cf231635828d12d9c064d795404ff049535778" => :catalina
    sha256 "7d729f53cf725dae16a5f7de79e69e583a62aef05bfd65d58deb0969b8b67171" => :mojave
    sha256 "586e65a329af130e0da3f1f72a40cacbc8b2e0f6c882d167907d6da3a4f7213b" => :high_sierra
  end

  depends_on "libgpg-error"

  # Upstream patch which corrects the pkg-config flags to include the header and library paths
  # Important on non /usr/local prefixes
  # https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=commit;h=761d12f140b77b907087590646651d9578b68a54
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/a367916e22d086d683ebed52f99a63bda2fc83a3/libgcrypt/libgcrypt.pc.in.patch"
    sha256 "f4da2d8c93bc52a26efa429a81d32141246d163d752464cd17ac9cce27d1fc64"
  end

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
      # Slightly hideous hack to help `make check` work in
      # normal place on >10.10 where SIP is enabled.
      # https://github.com/Homebrew/homebrew-core/pull/3004
      # https://bugs.gnupg.org/gnupg/issue2056
      MachO::Tools.change_install_name("#{buildpath}/tests/.libs/random",
                                       "#{lib}/libgcrypt.20.dylib",
                                       "#{buildpath}/src/.libs/libgcrypt.20.dylib")
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
