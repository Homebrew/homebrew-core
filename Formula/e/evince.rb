class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://apps.gnome.org/Evince/"
  url "https://download.gnome.org/sources/evince/46/evince-46.3.1.tar.xz"
  sha256 "945c20a6f23839b0d5332729171458e90680da8264e99c6f9f41c219c7eeee7c"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "187802b2b1cc63ac443b9cffa900357c13e485ca2ee3d81970201594a5b19e3c"
    sha256 arm64_sonoma:  "09a6b41784e63e2f35595fd42d1f758cc2ac7be587de787a264b4d7d916acae5"
    sha256 arm64_ventura: "40a136500823af6de06b4f58f6c967bf2805afe2b83d94bc7925744258eb7c5f"
    sha256 sonoma:        "bc0c4395ecd99384e26ba2a63cdd27445b4cf0a069c15a95d1af1f92beb966ff"
    sha256 ventura:       "61ed6db368b8d760df540b2b5f5e0ac8b983d7e0b5cd98dc3d34d4f9629937d9"
    sha256 x86_64_linux:  "7f1f11b14ac0c6534b3f957e431b70e1dc7067c590370b342656bfe2d3551cec"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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
