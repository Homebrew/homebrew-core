class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.18.2.tar.xz"
  sha256 "46964928742733fffcf8ca65d37ac0874c8ccd6270cbc065cb1013cee94e9e3b"
  license "GPL-3.0-or-later"
  head "https://github.com/profanity-im/profanity.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "db226be2bfadd4f947d10df20bd56515807400ab6a116f47f1b9f9e9e3c313c2"
    sha256 arm64_sequoia: "34daf7682c6ab0225c7e3b3109bb885d19ee3d485aabf8ac7a592fca6b15bd3d"
    sha256 arm64_sonoma:  "f8fd013b0c8194ebea2c3c266a8bc71a11a2ffb92d18e6fed8274089219ffca4"
    sha256 sonoma:        "6d4951d4ac8850b111e550183091e3ef63d80c080ac32e97f62af9fbb51093bb"
    sha256 arm64_linux:   "6e973dff83a86be94d0e5f976a32a113f438fb935ed8c52f3cefeb1c61eaf656"
    sha256 x86_64_linux:  "39e42b641a2108c51dd846cc9f89d1c44bf935fc1b48deadee9eb5184c94b719"
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
