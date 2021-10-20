class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/41/evince-41.2.tar.xz"
  sha256 "95abad0d6feeac9560db3ab80ba7c5eabb1fdf1ca0e3b3c93339af05453a24d8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "a28c94396bd1929ab1d0cd167d80e3ca438f5fa57349c471095ae02101993e5a"
    sha256 big_sur:       "7e3cdcb6113ebed08f69bf2832022e5c13f8bf49b039e11aee40ec449fb4c7df"
    sha256 catalina:      "b6f7b1321a1a9eb72ff71f63953af22c8f7b956916a5f7a82ebb3647850ae0f1"
    sha256 mojave:        "39946fe1263fbc1eeb1734c09f037336dff6a97f6eedf6b555757ad3e2847c59"
  end

  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "python@3.9"

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dnautilus=false
      -Ddjvu=enabled
      -Dgxps=enabled
      -Dcomics=enabled
      -Dgtk_doc=false
      -Dintrospection=true
      -Dbrowser_plugin=false
      -Dgspell=enabled
      -Ddbus=false
      -Dps=enabled
    ]

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
