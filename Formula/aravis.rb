class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/archive/ARAVIS_0_6_0.tar.gz"
  sha256 "d7c047af9c845a3e036557b6e5d715da0c21eeb314f704a257f8636fcb634af6"

  bottle do
    sha256 "535b46c36a805622b39db2f1eb0ee30b9a16a3b1cccc99af0fea4253f58a2b76" => :mojave
    sha256 "e4b43a8840f5e21a9acc48faaced67a58432deb26d38c632d5b8ccda129f2dca" => :high_sierra
    sha256 "33f2fb3607b7547ac3505c42f74743fa4cd281044bda83a3348e20e3fc5c0a79" => :sierra
    sha256 "1594fd0d1117da017a5934b5c1444b7ff0f1642817640f33dc12bf23b3a8e5ba" => :el_capitan
  end

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
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.0.6.so")
    assert_match /Description *Aravis Video Source/, output
  end
end
