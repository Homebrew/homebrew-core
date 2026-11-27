class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.20.0.tar.xz"
  sha256 "371f3c987a1800905632dc04b28c980acce8a5783eba55e8b1f9c5ca1df266f4"
  license "GPL-3.0-or-later"
  head "https://github.com/profanity-im/profanity.git", branch: "master"

  bottle do
    manifest_sha256 "ec688c51c079adca48b5f66cff1f2d7fb7f404f6cfe6d8236b24efec82a60da1"
    sha256 arm64_golden_gate: "5a28ad0761eedf5992728ffab64fe33d53f3d1f1131e6b7974dbb4ad63fad817"
    sha256 arm64_tahoe:       "5fb38ee91e6cc8108526c585e3a4ebfb129c369c49f3aea6e4031555073e5900"
    sha256 arm64_sequoia:     "64e3e150bb8624ecef473365be54eaf86145909b8a397455f020d97925e6f29a"
    sha256 arm64_linux:       "0dafd91d852afef58162651fb4c67815b793d5087f427bef12356de1bd172685"
    sha256 x86_64_linux:      "83af0b90702018319134166a9be0f070880bde45707a34be0d7d78f2a1b8e0de"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libomemo-c"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "lua"
  depends_on "qrencode"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "terminal-notifier"
  end

  deny_network_access!

  def install
    # Meson shells out to `brew --prefix readline` on macOS if `dependency("readline")`
    # cannot resolve directly, so keep Homebrew's `brew` executable discoverable.
    ENV.prepend_path "PATH", File.dirname(HOMEBREW_BREW_FILE)
    # Meson strips its build rpaths on install, dropping the matching `opt/*/lib` entries from superenv
    ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib" if OS.linux?

    args = %w[
      -Dnotifications=enabled
      -Dplugins=enabled
      -Dotr=enabled
      -Dpgp=enabled
      -Domemo=enabled
      -Domemo-backend=libomemo-c
      -Domemo-qrcode=enabled
      -Dtray=enabled
      -Dgdk-pixbuf=enabled
    ]

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"profanity", "-v"
  end
end
