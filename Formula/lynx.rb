class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.bz2"
  mirror "https://fossies.org/linux/www/lynx2.8.9rel.1.tar.bz2"
  version "2.8.9rel.1"
  sha256 "387f193d7792f9cfada14c60b0e5c0bff18f227d9257a39483e14fa1aaf79595"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://invisible-mirror.net/archives/lynx/tarballs/?C=M&O=D"
    regex(/href=.*?lynx[._-]?v?(\d+(?:\.\d+)+(?:rel\.?\d+))\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "815b132d26bdb96a9631b8ef6582ea68d24345929fa27e5139c2fbfb54977b16"
    sha256 arm64_monterey: "cce0820f34703a1c58f6438020653a5b5e529fda2ad408b2868ee2ad385f454e"
    sha256 arm64_big_sur:  "4a2d0e0392f714f2bdcc03ab924aee26235f37bcebdc896bae9415947a7d0c77"
    sha256 ventura:        "6ad78b71b9cffebb1f4e4893f9301bb6ddfc6de5b9531fe4b2c5edccb60a2740"
    sha256 monterey:       "07114f2eeeb2d3dae0761fbf14505a24f6c71e6b56c233092171605739b96459"
    sha256 big_sur:        "eeda5a5569d97234c0f69378bb5a71a78a4d3dea5211c1e2830c19853f9270b7"
    sha256 catalina:       "da24cd977b30037c578f1a6f90b816cb463925fce34621630b3d41ebe890ef59"
    sha256 x86_64_linux:   "de67ee9f6cd1dd1a9147d4b6240abec83111043de0a743768b1ed5d1c581aa5b"
  end

  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Using --with-screen=ncurses to due to behaviour change in Big Sur
    # https://github.com/Homebrew/homebrew-core/pull/58019

    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          "--enable-ipv6",
                          "--with-screen=ncurses",
                          "--enable-externs",
                          "--disable-config-info"
    system "make", "install"
  end

  test do
    system "#{bin}/lynx", "-dump", "https://example.org/"
  end
end
