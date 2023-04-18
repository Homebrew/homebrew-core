class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/44/baobab-44.0.tar.xz"
  sha256 "845b63bb9123d74568c8126c571bbc74273483ff920179a2cf1eddbbefa1bfc0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "51ceb0c963e73eed95c217497c225c1567a96bd0c351bb8fdd8f0f340096f637"
    sha256 arm64_monterey: "6415103c8d7a5abb1cd0d3964b7e0e4adb2b648952c5a765de3406625de2c0ca"
    sha256 arm64_big_sur:  "e344b2469eed54edaea7e2e643d7018075cf212d3d715b991dbdb5d87ae6ae63"
    sha256 ventura:        "b3ab0b152bbb0e004e9bb4e297494f530b8a6e4aceb68ed1fde9fb46e058b18e"
    sha256 monterey:       "7045d114d65ca8b07f7534fff54959329a147803051a8772d17ad8e192a179b5"
    sha256 big_sur:        "91f456b18cbb84f6dd510bb3faf7593ff2c735b361b9a26fa3611d5cc9c01a1e"
    sha256 x86_64_linux:   "5bf6be47037b1bb21274c6bee9544c15805280705bc9a9d52b5b1445c9a3ba67"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
