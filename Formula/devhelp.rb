class Devhelp < Formula
  desc "API documentation browser for GTK+ and GNOME"
  homepage "https://wiki.gnome.org/Apps/Devhelp"
  url "https://download.gnome.org/sources/devhelp/3.22/devhelp-3.22.0.tar.xz"
  sha256 "59cae02e12d238cc5fc3f049d779895ba89701426d9173f5b534d4ab90c5ffb0"

  bottle do
    sha256 "92f3c878dfaa3ce20cd2c29c9a5a8ccb128c0c2ab2f3440355a1fbbe441f97f0" => :sierra
    sha256 "b375e414ba006a49497ac7cbda0dd94f5647a2e0d5fb1043e18f43d225694171" => :el_capitan
    sha256 "54e284e4ee6e6ea75b75762fda2e095cc37846b64fc39b54c579afe479b906c1" => :yosemite
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
