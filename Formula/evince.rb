class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/42/evince-42.2.tar.xz"
  sha256 "ff7f81f308cf8d4956ed97fb724a7e49448c214beeab998812ef9efbb38df8ae"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "d69c944885f800cae888f0d25ee40ccee11378fdf4892472aa4189c15a515515"
    sha256 arm64_big_sur:  "dab0eba135eefc60c69d8781a29940ef9a92a947843aabcf29d02d0085d165bf"
    sha256 monterey:       "b3c8f7fdde11e14d57e09d4d82e39c78de7b8f2548395c642898b9f94c70c4c3"
    sha256 big_sur:        "6df0eb2d7dcce978a49bf186629ea345285cb2c5bff4d87682557ebaa5b211e5"
    sha256 catalina:       "340bd9932eaf6b9e3c476103b49d1d26816e889041201c9c8228a8d8e1b26b7a"
    sha256 x86_64_linux:   "350b2ccdbe84bbfe935e8785512a80323627ee2326b42861314f1e3df3c85739"
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
