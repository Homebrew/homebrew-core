class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/archive/ARAVIS_0_6_0.tar.gz"
  sha256 "d7c047af9c845a3e036557b6e5d715da0c21eeb314f704a257f8636fcb634af6"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.0.6.so"
  end
end
