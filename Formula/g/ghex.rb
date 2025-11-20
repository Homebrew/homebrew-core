class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/48/ghex-48.3.tar.xz"
  sha256 "cbc84427b2adea9403502a125f366b9f288813f72e81bf6b19154606f159dd39"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "28c03f317c94d3fa0f0d8fb4e83e71b9558b9d301d287b76a1590a5bbf499414"
    sha256 arm64_sequoia: "29e87247e5434888b03fa07223c4df2414e2dd1dc4a10586d661eaf1c1befa2c"
    sha256 arm64_sonoma:  "4e7a1d4c2c85ca5eefe98d25793f0bbd0e0a056926119051a36963773a428252"
    sha256 sonoma:        "a54e12aff1120f1edf01d8179eec69aabd44b6fdacc3f8a4f94f30d66e9cf614"
    sha256 arm64_linux:   "76d601774e3d566e5a44e9148e9cbe7621898508ea5b7cc5a45c879ea9509989"
    sha256 x86_64_linux:  "90dea601a000ddab7edaf0fdc98abe0dffee0760e0995f5520f3bb7904d32c46"
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
