class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/40/evince-40.1.tar.xz"
  sha256 "7a666363c350af2e3bbba7f14b3c1befc5012f9ed3d9d073447f4c59f33dcf2d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "46095e44592ac8dd8ec33eb05a96902142bb1e92ed3ae7c227e960518ad3847b"
    sha256 big_sur:       "4564da807d2e2d42681c4aa8831cae2b5532076d3250d92ca5312ccc9bf9f59b"
    sha256 catalina:      "2f2141d9d80ce35e071924cf983a5dd68629a0c6b86dc79dec456816a4c3480a"
    sha256 mojave:        "4b0c02cfc6338414f30648b433554d334e08233c0686e929cef0773fe48b3898"
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
