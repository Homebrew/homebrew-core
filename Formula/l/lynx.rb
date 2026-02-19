class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.9.2.tar.bz2"
  mirror "https://fossies.org/linux/www/lynx2.9.2.tar.bz2"
  sha256 "7374b89936d991669e101f4e97f2c9592036e1e8cdaa7bafc259a77ab6fb07ce"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/lynx/tarballs/?C=M&O=D"
    regex(/href=.*?lynx[._-]?v?(\d+(?:\.\d+)+(?:rel\.?\d+)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f018c40ffe24220383f1e020875f64a62552bedc10e4948321992a4ceac5e83e"
    sha256 arm64_sequoia: "3a912438a909ec79166e61ea5b9dea7376b0d3e0bf566d5de723697c2427b807"
    sha256 arm64_sonoma:  "174ecc0b2aebe7c14294bdc63f7052d93405ac48021c9b81eea4e4a668830fae"
    sha256 sonoma:        "5a3157c1ed95544f85968690b9d51c36975d1cc52c75069328d9ea6de28c4ae5"
    sha256 arm64_linux:   "fceb7120d16369c1cd5350ff34a39f3d8276061a5119a64eec00be26ffc6e5f5"
    sha256 x86_64_linux:  "6267a025209071f6109d8b8cfcb81de136bac11ead8b19ae2aa644ab74fee8fb"
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
  end

  test do
    system bin/"lynx", "-dump", "https://example.org/"
  end
end
