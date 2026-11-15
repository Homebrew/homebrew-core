class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.19.0.tar.xz"
  sha256 "fa201a10df688a173a0ce61da3be528f8e03f44d72817ed327568acb1c8fb259"
  license "GPL-3.0-or-later"
  head "https://github.com/profanity-im/profanity.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "e8f73582a912a2325a042ccc35cae563528d1585a68ccc03c6967799e9c861e0"
    sha256 arm64_tahoe:       "1cb182a6a25209e7c7e5c5aa0f22698ae5d4d38c8b298f7eace2808dfdad37b9"
    sha256 arm64_sequoia:     "a949cabe1b7e4a600e16f4e02991b4a16d941aaac20249c32eb227a7da0652c9"
    sha256 arm64_linux:       "3b68547440e6ee4cb5fd934752ff4b6663c257078a9329bf8dd99669cfa41dda"
    sha256 x86_64_linux:      "98bf38f2693f545cac295d6ef9d07893b136a9871d640a161c6f6119917ed430"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "gtk+3"
  depends_on "libgcrypt"
  depends_on "libomemo-c"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "libx11"
  depends_on "libxscrnsaver"
  depends_on "python@3.15"
  depends_on "qrencode"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "terminal-notifier"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    # Meson shells out to `brew --prefix readline` on macOS if `dependency("readline")`
    # cannot resolve directly, so keep Homebrew's `brew` executable discoverable.
    ENV.prepend_path "PATH", File.dirname(HOMEBREW_BREW_FILE)

    args = %w[
      -Dnotifications=enabled
      -Dpython-plugins=enabled
      -Dc-plugins=enabled
      -Dotr=enabled
      -Dpgp=enabled
      -Domemo=enabled
      -Domemo-backend=libomemo-c
      -Domemo-qrcode=enabled
      -Dicons-and-clipboard=enabled
      -Dgdk-pixbuf=enabled
      -Dxscreensaver=enabled
    ]

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"profanity", "-v"
  end
end
