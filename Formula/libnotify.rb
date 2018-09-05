class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://developer.gnome.org/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.7.tar.xz"
  sha256 "9cb4ce315b2655860c524d46b56010874214ec27e854086c1a1d0260137efc04"
  revision 1

  bottle do
    sha256 "d45147d1218ee584b2d67ce23e6bd60553a83424c3c0a69cd8a14f6e238a398c" => :mojave
    sha256 "f88f445a6b5719c695aa606da3050d3e24ddc1c7a586f6541186025551d273e6" => :high_sierra
    sha256 "09166e1efa743eed930b7aca87b084de644735f8af17133bf697e24b70f8018f" => :sierra
    sha256 "0139ddf8047c88ee6c29abfa8a112dce897150d54a0d83b9d2892d5033829a6d" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-tests",
                          "--enable-introspection"
    system "make", "install"
  end
end
