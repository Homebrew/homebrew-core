class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.38/evince-3.38.0.tar.xz"
  sha256 "26df897a417545b476d2606b14731122e84278ae994bd64ea535449c3cf01948"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
  end

  bottle do
    sha256 "9f384c55efe4fda1409a660fbbabd6cd8a05ec126b42b7c9f594c5d610656e1e" => :big_sur
    sha256 "6168bdf584ff3088fe940fb37ba6e9027b6357c7f219e176314549d3b4717b10" => :catalina
    sha256 "420cc235e69f6ef1c680219661d3d0b9c47dda3882309e3529f140ff32ed1234" => :mojave
    sha256 "61f3ac0d9205848c9a1163558e7e343d794672b64a5c10d3156bd734ce5274f1" => :high_sierra
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
