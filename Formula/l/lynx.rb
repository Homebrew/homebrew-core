class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.9.2.tar.bz2"
  mirror "https://fossies.org/linux/www/lynx2.9.2.tar.bz2"
  sha256 "7374b89936d991669e101f4e97f2c9592036e1e8cdaa7bafc259a77ab6fb07ce"
  license "GPL-2.0-only" # with non-SPDX exception in COPYHEADER to use OpenSSL and other libs

  livecheck do
    url "https://invisible-mirror.net/archives/lynx/tarballs/?C=M&O=D"
    regex(/href=.*?lynx[._-]?v?(\d+(?:\.\d+)+(?:rel\.?\d+)?)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "dbadf2d9dcbb3567e809071dc8d240fbb4d6c229d44fd4a9fed0c98e14fbb818"
    sha256 arm64_sequoia: "f596d1b37e3bb877c1e6cf8435504f7ef39920ac09d26040c4bae18da07791d2"
    sha256 arm64_sonoma:  "35f0588c3df08e80fb0a4fde74ac5f7c33a918d890a085791f557299b5617154"
    sha256 sonoma:        "82690721857094cf83bc59cdbf0c4feedada05ea7b902c5abeb7771273c74476"
    sha256 arm64_linux:   "837b50b6330b76cf666e0c6134a1e4f3fc79ea03197c59059bcf0f5db6244576"
    sha256 x86_64_linux:  "090af405647a09276b97bf5e3f4ef22a216950563ae19749c57e16142f09749f"
  end

  # Move to brew ncurses to fix screen related bugs
  depends_on "ncurses"
  depends_on "openssl@3"

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
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
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
