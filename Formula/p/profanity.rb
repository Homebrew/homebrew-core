class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.18.2.tar.xz"
  sha256 "46964928742733fffcf8ca65d37ac0874c8ccd6270cbc065cb1013cee94e9e3b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/profanity-im/profanity.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "30b0296eed40de1140470010da6fe562574a802c6f41ff1848e519e897b7971f"
    sha256 arm64_sequoia: "047d3d9b82750ac907046107803d465738dec5692b6180cc931f8b234cbe0940"
    sha256 arm64_sonoma:  "509d59ceaab4bdf334f58e24af6391bc9b2151345b40ac95038299fd8399a36e"
    sha256 sonoma:        "107b58f0db1b558f20f76e59633ebe6f628ebd7dd1a44406d62fee8c85e5551b"
    sha256 arm64_linux:   "c1862ab73b74923268ae57e7ebc966cc5804bff0ae4b6eaf5023f28c74b07e86"
    sha256 x86_64_linux:  "f3512d92fd693b0e65dcd9912c7166652f04d2cc9829d22fa76d5df04ae970d5"
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
