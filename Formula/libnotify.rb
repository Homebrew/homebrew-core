class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://developer.gnome.org/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.7.tar.xz"
  sha256 "9cb4ce315b2655860c524d46b56010874214ec27e854086c1a1d0260137efc04"

  bottle do
    sha256 "7b9bbf7af44434aca82465bf7f234d4affb50daeae54c65a7758b9814e113ff5" => :sierra
    sha256 "6c0c8e5b8b9e38ff2820b7df7aefb1510d95a5f9dcb31b37ed800da0c737f4e1" => :el_capitan
    sha256 "c0646c9d0c3b53290875df575a3b97fb30c852a70825e048b70475ed1e9e72d5" => :yosemite
    sha256 "e4f657ff6ecaafa2e448c86521330ba3fbc0ef3181b0608808fe32f03f4fb80c" => :mavericks
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
