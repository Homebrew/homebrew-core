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
    sha256 arm64_tahoe:   "993d69e6e720f3d34b3488b2428995be5f9f07bc6455131a5130d3566b9ad793"
    sha256 arm64_sequoia: "d19f769a462343c54bade40fe15b7a3a6ea52a927dd1e3494ea1b2301fe63b81"
    sha256 arm64_sonoma:  "4bf5b522776f2578692e8a19f113007fd9849131731782e9b681a6317103b945"
    sha256 arm64_ventura: "20953b360eb23fd1ef4b7a7ee5f3b846e01d7d6c1190280aabf202d68245a46e"
    sha256 sonoma:        "37094ec003457ab4fed45872f08bd9452331c57421c46c7fe2e59c494ef7f936"
    sha256 ventura:       "f54a50e56b2b754653afdffde634524b10bc607fc5f6f24d8b4c1cd417fbd48d"
    sha256 arm64_linux:   "f31950d24b91885f8887fe341be40af6f9fd33ec2ffab1f3c41def4ec48cbab9"
    sha256 x86_64_linux:  "2d30e3d55c3916b4a3c488034680170553d4ef090e717cf74d6782348115cdd6"
  end

  # Move to brew ncurses to fix screen related bugs
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
