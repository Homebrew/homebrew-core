class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://wiki.gnome.org/Projects/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/2.0/goocanvas-2.0.4.tar.xz"
  sha256 "c728e2b7d4425ae81b54e1e07a3d3c8a4bd6377a63cffa43006045bceaa92e90"
  revision 1

  bottle do
    sha256 "3449f3d31f5b9f3b6fed3cd4ea5a2941663a7ff4f8e1559a3439996f0d79068b" => :mojave
    sha256 "79ef1d7dd6f20f0b26c171bbe38243d8e21167b27080488b45723ef1a1eb53b1" => :high_sierra
    sha256 "e006d106b20aa040106983b51142bf134dd1925f4e6df11f09a89fea96189a22" => :sierra
    sha256 "26d6c8d30f7a9056af03e59691a4112147cff745855042244413b83be99c7ae9" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
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
