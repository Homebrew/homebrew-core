class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/40/evince-40.2.tar.xz"
  sha256 "0ff7ec79376a8a97ac4cd274d32e804c7e236ef2d2d5d3f646de6eb882a63c77"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "7ee19ddeb17483a20af46196e737ab22c4d99d71bbe4ef8a3bda580ccbd1167b"
    sha256 big_sur:       "c674d4c58ad1567dc7347f01a40507b26f71831fbeaad011c3ce49185843cbeb"
    sha256 catalina:      "00c7846c099779d59558f25851b647d5f5da50c6d4b1fad11bc4268b04d307e0"
    sha256 mojave:        "3d6e92d06a93a93d378ab8700ebf1759593949ecbd15b807f7ea82bd33bc2fb7"
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

  # patch submitted upstream
  # see https://gitlab.gnome.org/GNOME/evince/-/merge_requests/348
  patch do
    url "https://gitlab.gnome.org/GNOME/evince/-/commit/5d08585702b6dfccc67098b501cfa99a01775c87.diff"
    sha256 "87dd01dcf68ddee832cc9931165bc8dd66c76cb09520072afd0354b02b600146"
  end

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
