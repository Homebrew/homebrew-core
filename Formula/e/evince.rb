class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://apps.gnome.org/Evince/"
  url "https://download.gnome.org/sources/evince/46/evince-46.3.1.tar.xz"
  sha256 "945c20a6f23839b0d5332729171458e90680da8264e99c6f9f41c219c7eeee7c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "21852215aea592397425ed58039e347dbea319f9fecae3f753cd5acdcc147b94"
    sha256 arm64_ventura:  "0cddc507eaf18b5d52c8f52983f3b646be142db4c8e470918534d66afdd0f19d"
    sha256 arm64_monterey: "69ccf42eee57f2e1558bad935514778be45476869fc9358212f8dde85ea1f4a8"
    sha256 sonoma:         "9cd783e163d622d63f0d1d5e0a48a7dde9aab95ceae0352fa0992c0b9acad2f3"
    sha256 ventura:        "40428930fe5a7a103e279f2b914ddea2e113f0a2831992067d564cc09e8d8c18"
    sha256 monterey:       "e4efa202ef6cf72f3ac992ba590523a26f438a73b502044202be3d1e9f4a8ab1"
    sha256 x86_64_linux:   "5547d26ffb2d3e5e96dc34180d02c5bceccc8b0d10eec5d262c2744f809f3d32"
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
