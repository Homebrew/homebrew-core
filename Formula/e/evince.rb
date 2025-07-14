class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://apps.gnome.org/Evince/"
  url "https://download.gnome.org/sources/evince/48/evince-48.1.tar.xz"
  sha256 "7d8b9a6fa3a05d3f5b9048859027688c73a788ff6e923bc3945126884943fa10"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "3f164382922aa3874259207d4bf340c9fe91d7dfc08da4457a26147b2ffb91e4"
    sha256 arm64_sonoma:  "37a63e9e26bd09f0a75942ce9f78915932623b1d753950712010952e710d67a7"
    sha256 arm64_ventura: "29c4dc38497d86d2fe33251d10da3720ef8942bc2ddfd63350f4af3b89ff9ae8"
    sha256 sonoma:        "d43f7a68f019e093c48d0fd99e2f8525b138d2faa9c1fe6c1d1e4d7194810d01"
    sha256 ventura:       "3083111580824c36689acec0375bae69eeec938daad04d14b91c0a545313b02c"
    sha256 arm64_linux:   "ddd42136c9a5045fd5269490000d15042f5aa632f935222d40fa67d788815528"
    sha256 x86_64_linux:  "4c00e8ea528a4d7e471eca5d728ed33dccfb205575fc3079601bedc72f07d79f"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "pango"
  depends_on "poppler"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build # for msgfmt
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
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
