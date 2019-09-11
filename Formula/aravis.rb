class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.6/aravis-0.6.4.tar.xz"
  sha256 "b595a4724da51d0fdb71f2b6e2f1e12f328e423155c3e84607ee2ce704f516bd"

  bottle do
    sha256 "b851c3d06486230de2a79a57d82455029cb07890749e4525dc929a075cce1c70" => :mojave
    sha256 "948909cbf756dc510beff0d8bb88d31f49b8d335d637b260592dff29608939f6" => :high_sierra
    sha256 "b97fa0af26f27a4a7ff3f56b6e24b300199ad7f208343a431e8ea90a806a9d9c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  def install
    # icon cache update must happen in post_install
    inreplace "viewer/Makefile.am", "install-data-hook: install-update-icon-cache", ""

    system "autoreconf", "-fi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-introspection",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.0.6.so")
    assert_match /Description *Aravis Video Source/, output
  end
end
