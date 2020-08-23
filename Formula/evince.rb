class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.36/evince-3.36.7.tar.xz"
  sha256 "65d61a423e3fbbe07001f65e87422dfb7d2e42b9edf0ca6a1d427af9a04b8f32"
  license "GPL-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 "6b0be18965aa27c500abf52cd0e1c5092eb304e8f3eb981031b0c9a98ff4f2b2" => :catalina
    sha256 "49f55d76c47e8bbe458d2a04a9721d550d71a7f4e74f4193e66af7d6b68b5232" => :mojave
    sha256 "6fd094df345b9355d9f8e6824b1e0d1aa3237f456a781bf19c6f038ab9196699" => :high_sierra
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
  depends_on "python@3.8"

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
