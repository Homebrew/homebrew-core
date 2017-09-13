class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://live.gnome.org/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/2.0/goocanvas-2.0.3.tar.xz"
  sha256 "6b5b9c25d32c05b9bafc42f5fcc28d55f1426e733e78e9fe4d191cfcd666c800"

  bottle do
    sha256 "ef387c378d0deff93c53b45c6910c537fa658ef0fd2bfb0b273fd5a7494d1725" => :sierra
    sha256 "d9e77f5e105c5aead29dd61f447dc2d805638ec1f3881923c3a8949c8c3de789" => :el_capitan
    sha256 "31ea24c91d6af157bdb47ab5d6fc7db1a3a2ce8c5fbfbb9fba21ce6fb9a1a13d" => :yosemite
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
