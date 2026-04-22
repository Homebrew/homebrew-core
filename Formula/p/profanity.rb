class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.18.0.tar.xz"
  sha256 "a1ad441bf92ba0327e0740a15dfe7885cb14415a934c850b8b98ac2f728d7cf8"
  license "GPL-3.0-or-later"
  head "https://github.com/profanity-im/profanity.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6ff33b65801254c3f687f682c32a4a2bf5ff7294a5ca17c73f9001eec73e3651"
    sha256 arm64_sequoia: "e47d5c5419642bfc391a63b41f837596afc2bc2701d47a10399c212a091b6fca"
    sha256 arm64_sonoma:  "032c901164d7e7e56e1fc82e3e4adc2fe33313a59ce30072101f906e13e5a553"
    sha256 sonoma:        "28226b645ad41cda17521ea9b5d265429cf74fdc2ef59a3a1297cd5fc48ca8c7"
    sha256 arm64_linux:   "11b138269c95cdd14e315f142874ed3f4b5dcd94d4b6bf80577922181248f40e"
    sha256 x86_64_linux:  "1ddd88181401770e9b1583f21228e01edb8bc721efee0fb0aa21a3b5928b8bc4"
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
