class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://live.gnome.org/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/2.0/goocanvas-2.0.4.tar.xz"
  sha256 "c728e2b7d4425ae81b54e1e07a3d3c8a4bd6377a63cffa43006045bceaa92e90"

  bottle do
    sha256 "b7124d1a527133154e512e1161139b548b6a85de02a60bb0af6a846609c9cfdc" => :high_sierra
    sha256 "a3606de14cd0673059212876471fcef7f77dad186c643b02f7dd1ce4298616e4" => :sierra
    sha256 "b668a762e8d82306d39be7f8bf72e739d3a6f84624b93c786f01a9c910854724" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes",
                          "--disable-gtk-doc-html"
    system "make", "install"
  end
end
