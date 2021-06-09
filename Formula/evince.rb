class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/40/evince-40.2.tar.xz"
  sha256 "0ff7ec79376a8a97ac4cd274d32e804c7e236ef2d2d5d3f646de6eb882a63c77"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "066464147690e5cf4542f59766596f310e33d31277854151d98576dbeb38da6f"
    sha256 big_sur:       "bc38c271ec13caed62c42adebe9ebc20468f69c1fc822dd2656310f2955049c8"
    sha256 catalina:      "dd9e4b8a15bb8c2228ae55ff06a136988ed926d3c0bb19a9035aa838bb77d6ea"
    sha256 mojave:        "a27f48b63081927d0d616ae477bd448893a07a652c0f0b88c395941ced7d8d63"
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
