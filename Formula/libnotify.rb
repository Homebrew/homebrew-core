class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://developer.gnome.org/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.7.tar.xz"
  sha256 "9cb4ce315b2655860c524d46b56010874214ec27e854086c1a1d0260137efc04"

  bottle do
    sha256 "7928ed78b1d0f0be06bb7ad177499f336543abea03433cc050e7d0de4be1dc35" => :sierra
    sha256 "edd371fcf6906fa7bbec21ce9ea038ce30e5c9fde400f6deef1eb89eb01e1601" => :el_capitan
    sha256 "e05515c53cdb39f36ff6001d2ebb2ac95dc4fc678ba80638373f71f0073d1a9a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-tests",
                          "--enable-introspection"
    system "make", "install"
  end
end
