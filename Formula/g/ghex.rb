class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/48/ghex-48.1.tar.xz"
  sha256 "4feab8af967e2763f28bc77a4ddcf54a367aa1d85496fef0501986bd803d89f2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "0743612db3f280b9f6f4eb9edc6ef087717950f6b85b8bb7e614861f6c23f64d"
    sha256 arm64_sequoia: "9d59d00a6725d30308c27cc4c1791947d43a1a9c65116e62e8a8bd339b45756b"
    sha256 arm64_sonoma:  "e96801c8f4fa698f685c2ca0b9652043eaaf1bcec7fd61ff2a9b52c0fc676e5a"
    sha256 arm64_ventura: "f4b4e41e35a47e43643f527cc3b7d3b5b0603b073fec381551a23758706590a0"
    sha256 sonoma:        "82a06b0771293756b14ae72ca5e212f159eb90b051fd1b14122095b52ccc2db2"
    sha256 ventura:       "91eee4aa68a37d41c0474dc8bc505f1beab077b30f765564470af0d73e1f9fcf"
    sha256 arm64_linux:   "39554767847929fbd586e60dde0689a9eb7b09eb16a46eefa53e618b365a424d"
    sha256 x86_64_linux:  "bb572c5815729bbaf7900191018ee7a4c4a910bb4e9913ee62dd7144e6778736"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -Dmmap-buffer-backend=#{OS.linux?}
      -Ddirect-buffer-backend=#{OS.linux?}
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # (process:30744): Gtk-WARNING **: 06:38:39.728: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"ghex", "--help"
  end
end
