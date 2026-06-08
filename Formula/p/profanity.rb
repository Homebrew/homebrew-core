class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.18.1.tar.xz"
  sha256 "9077e82dcc45ec38fa907cbfc7d63bd3f1344086cbd855f2d432658b06dee30a"
  license "GPL-3.0-or-later"
  head "https://github.com/profanity-im/profanity.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "d12f4ff0e5cf24d5645119c9365f901e41e7ee7e58936fb7809e0ba9ba898fb9"
    sha256 arm64_sequoia: "134b5409d8f3c3dcba52aa78bd38b6a3c725508b14763e6f0fc5116d7f31d42d"
    sha256 arm64_sonoma:  "bb5f115ebd5a4d957080e1f4970fea02c6441dea33a663874f729f5c8ac0ba44"
    sha256 sonoma:        "299f7308b309ebe018de7931d9ba9a56d44738747b75b73611189440c4f7873b"
    sha256 arm64_linux:   "71e950fef1bb64c85bf8a61e3887512f2eb61ccbe92692ca75291aeddb9a364d"
    sha256 x86_64_linux:  "282048cdd484579fb24e27bf550e0541ef8bdc160aa29116c55a93bd93cc7620"
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
