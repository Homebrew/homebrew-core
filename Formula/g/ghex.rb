class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/46/ghex-46.1.tar.xz"
  sha256 "8a13975474eee27719b29ad763f1b24760a1aede6d7da4b623703070bc26e9fd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "3ae1f8067843720a0bfd3ef85bb68fed839731804b2b6fff5bdbd9cee014eb5f"
    sha256 arm64_sonoma:  "c263eead912482887db29e9bb781fe9a1f0521a4a1c32f0df4894d1577b8a2f5"
    sha256 arm64_ventura: "611463e1e6cbb96ad5c148a20fc02eceabe39165bf36e60707adcaa487bfd3ce"
    sha256 sonoma:        "4d8f423eaf7012f76d805c8d954bd95dd61e6db3cad4a7955b05d801cab4879d"
    sha256 ventura:       "2ed3dcb13712cb3b7c8e45c8def49043621645ba3242bf0680017cfd13b73651"
    sha256 x86_64_linux:  "6d732a55bb48bf5d8895cdf7eb05f3853748388e2e344dbec0678b54a144c538"
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
