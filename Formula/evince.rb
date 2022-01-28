class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/41/evince-41.3.tar.xz"
  sha256 "3346b01f9bdc8f2d5ffea92f110a090c64a3624942b5b543aad4592a9de33bb0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "d69c944885f800cae888f0d25ee40ccee11378fdf4892472aa4189c15a515515"
    sha256 arm64_big_sur:  "dab0eba135eefc60c69d8781a29940ef9a92a947843aabcf29d02d0085d165bf"
    sha256 monterey:       "b3c8f7fdde11e14d57e09d4d82e39c78de7b8f2548395c642898b9f94c70c4c3"
    sha256 big_sur:        "6df0eb2d7dcce978a49bf186629ea345285cb2c5bff4d87682557ebaa5b211e5"
    sha256 catalina:       "340bd9932eaf6b9e3c476103b49d1d26816e889041201c9c8228a8d8e1b26b7a"
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

  # Fix compilation failure due to incorrect args for `i18n.merge_file`
  # https://gitlab.gnome.org/GNOME/evince/-/issues/1732
  patch do
    url "https://gitlab.gnome.org/GNOME/evince/-/commit/1060b24d051607f14220f148d2f7723b29897a54.diff"
    sha256 "5e9690beee8a472148a7c6fda78793a3499d5d0c38e08f61e1589598fab68f1a"
  end

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dnautilus=false
      -Dcomics=enabled
      -Ddjvu=enabled
      -Dpdf=enabled
      -Dps=enabled
      -Dtiff=enabled
      -Dxps=enabled
      -Dgtk_doc=false
      -Dintrospection=true
      -Ddbus=false
      -Dgspell=enabled
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
