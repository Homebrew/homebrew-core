class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.17.0.tar.xz"
  sha256 "508e18c0e797d46cc38779eb207480fc3e93b814e202a351050f395c1b262804"
  license "GPL-3.0-or-later"
  head "https://github.com/profanity-im/profanity.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "2f567c165e355a6aa6b0d577f03c856791df3ddebd3f9ffbd595665761efd073"
    sha256 arm64_sequoia: "edf9f7f259796f41180caa949a6ebc8c84a383c4226c4a59a995001f6fefcf7d"
    sha256 arm64_sonoma:  "693892cddb95d56dff09da433c86da52f38a51dd5c70ea58d26241595b62d34e"
    sha256 sonoma:        "537fc9ab1f71f61916f5ec8ce45b58c6e6340fd01eca667d8d7320a6af546c39"
    sha256 arm64_linux:   "4d2caeb7dbf41a46e3ff90c34689a864153f5866944fb6fa99ea8e270e3952b8"
    sha256 x86_64_linux:  "ae8c6b511ccd488753ca14b0af9996c518ec7093ddb46c60868a966807bedb91"
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
  depends_on "python@3.14"
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

  # Fix missing imports for libomemo-c support: https://github.com/profanity-im/profanity/pull/2133
  patch do
    url "https://github.com/profanity-im/profanity/commit/9a501e6ecdaf65d28362e5888a0529fb734a353e.patch?full_index=1"
    sha256 "ac0f514496890bbcbed9cee3f6a84387c64f3a299d9b2f700e07ae57bb887447"
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
