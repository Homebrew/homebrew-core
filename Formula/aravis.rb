class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.6/aravis-0.6.4.tar.xz"
  sha256 "b595a4724da51d0fdb71f2b6e2f1e12f328e423155c3e84607ee2ce704f516bd"

  bottle do
    sha256 "f7ec81b740fa25fd7c0fbdf94b8abdadb3afccdda6225b209493d85efdfe3558" => :mojave
    sha256 "9c3f1816595219a8e21982ae52d1197d1b53f920f0baa57254ca268d8f06cbce" => :high_sierra
    sha256 "eb3a787c91288e0c9d8a2c0211844e7c988b24d031f07f275a917cd71712f297" => :sierra
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
