class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.38/evince-3.38.2.tar.xz"
  sha256 "27d419d5fed6305e074628edcfde0cb734fffda205d63cac323391c04903bd94"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "31c52765fbb7507bed1fc93c4638c2c8dd5b1819fc86318a298da6f686c8bffb"
    sha256 big_sur:       "8d1947ce12210d9983d7f5054e40da839ae3e534f13c8332dbd0b74403918af0"
    sha256 catalina:      "8b9970bb044e1545185233a2eb60fb75e5f6bd8d8b23a19a55cbb611499d3314"
    sha256 mojave:        "52904ac87db4caaca4358e40c58c0ac5e532faed724aa80b4dea9714048404b0"
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
