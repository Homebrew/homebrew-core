class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.9.2.tar.bz2"
  mirror "https://fossies.org/linux/www/lynx2.9.2.tar.bz2"
  sha256 "7374b89936d991669e101f4e97f2c9592036e1e8cdaa7bafc259a77ab6fb07ce"
  license "GPL-2.0-only" # with non-SPDX exception in COPYHEADER to use OpenSSL and other libs
  revision 1

  livecheck do
    url "https://invisible-mirror.net/archives/lynx/tarballs/?C=M&O=D"
    regex(/href=.*?lynx[._-]?v?(\d+(?:\.\d+)+(?:rel\.?\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b09ddbe33e1e219183d99898e65aad94084ac685657203a1ac1f64a584e45c22"
    sha256 arm64_sequoia: "6eb6e6941ef97b8a19cb4dbc39c27dbd3accb6a3f8d64f1700f4f32ed2810d57"
    sha256 arm64_sonoma:  "34ab10d18649a2d01a70358ca8b7e37b6a4f6f5ddf8a35e5d8058914c912ff8c"
    sha256 sonoma:        "d4647fcb2b60ec32056e395eebf2fece4d20dbce9968e4c8046133be6f701be6"
    sha256 arm64_linux:   "af87f614a7653a2f5aa891b467721b781ae1e3f8b746f68d1c4eb7a4753c39cf"
    sha256 x86_64_linux:  "955b23500f5f853d2baf9fe16c82347e078e183f75db73001efcd7705d92a143"
  end

  # Move to brew ncurses to fix screen related bugs
  depends_on "ncurses"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Using --with-screen=ncurses to due to behaviour change in Big Sur
    # https://github.com/Homebrew/homebrew-core/pull/58019

    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl@4"].opt_prefix}",
                          "--enable-ipv6",
                          "--with-screen=ncurses",
                          "--with-curses-dir=#{Formula["ncurses"].opt_prefix}",
                          "--enable-externs",
                          "--disable-config-info"
    system "make", "install"
    prefix.install "COPYHEADER"
  end

  test do
    system bin/"lynx", "-dump", "https://example.org/"
  end
end
