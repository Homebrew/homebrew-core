class Devhelp < Formula
  desc "API documentation browser for GTK+ and GNOME"
  homepage "https://wiki.gnome.org/Apps/Devhelp"
  url "https://download.gnome.org/sources/devhelp/3.22/devhelp-3.22.0.tar.xz"
  sha256 "59cae02e12d238cc5fc3f049d779895ba89701426d9173f5b534d4ab90c5ffb0"

  bottle do
    sha256 "e999f76766f1295f883047354d2ad4aeea0de699773844c48872bc7a0c16b615" => :sierra
    sha256 "20c195d75481de422ec0e65b7efa3f6817cc6a603c0f37b9b4c90212df912552" => :el_capitan
    sha256 "383468387249e03b2fedaadb308835fa3425b1c27fd9db4cc1ac39c688bb5adf" => :yosemite
    sha256 "f33332669eb47d404ea73fbc99fe89e5d33f5044cc8b93acee84f274dc343a32" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "webkitgtk"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"devhelp", "--version"
  end
end
