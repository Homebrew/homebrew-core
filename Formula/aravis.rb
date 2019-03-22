class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/archive/ARAVIS_0_6_1.tar.gz"
  sha256 "d9795d36bfb1af230bda21d93bc81390f49d936c6c9b7b3043a5c09bd0f0f8d3"

  bottle do
    rebuild 1
    sha256 "48bd639c714321d52ae4beff4a6ee94e130b3e538bae1df9527bd48f3d9aef7f" => :mojave
    sha256 "e13f65a8fdca765cfc842faf4481d9e0ee84b7af116f251fa21efef5e85ad068" => :high_sierra
    sha256 "ff24dda20db8c14a54ff34b11f7da695e29afb426df7ae91c97fd341cb0b39d8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  def install
    inreplace "viewer/Makefile.am", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--enable-introspection",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.0.6.so")
    assert_match /Description *Aravis Video Source/, output
  end
end
