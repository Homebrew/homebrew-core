class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.9.3.tar.bz2"
  mirror "https://fossies.org/linux/www/lynx2.9.3.tar.bz2"
  sha256 "174b7f2866a60f3247ba75f5c7dbb10b124aede4a1359312de15f3bfebd2050f"
  license "GPL-2.0-only" # with non-SPDX exception in COPYHEADER to use OpenSSL and other libs

  livecheck do
    url "https://invisible-mirror.net/archives/lynx/tarballs/?C=M&O=D"
    regex(/href=.*?lynx[._-]?v?(\d+(?:\.\d+)+(?:rel\.?\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7402f2557043f9bcf6c927c53c83a2b656d3080d8a90127b7eb033a1941325c0"
    sha256 arm64_sequoia: "6455e96b5abc00fd0baac1dc6363261600b1265b0755411d5cdfb2cc5462c5e8"
    sha256 arm64_sonoma:  "624b9803ceb52e0d43c4f2702ed2efbf9848617d708559858ed67c26bbbeaf2b"
    sha256 sonoma:        "b9731435704ba12929ba5ef169655e0aafdfd112ea9613155894394d9feef6e7"
    sha256 arm64_linux:   "9b5dd269a12f18d6141cbdfbc333fa06f01e40753a56d7ce69a82b462ff8c972"
    sha256 x86_64_linux:  "6bb1b89675b6b39d7c532d1f767eae567b53b232b9e94e3048df3e1c577c0b05"
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
