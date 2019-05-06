class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.6/aravis-0.6.2.tar.xz"
  sha256 "a78b7bc98f93beb8116f796a9799ed1a364f05a6685e3f14bb09d9ac7a7858af"

  bottle do
    sha256 "09d57461fbdb8882389b4ea25ec99bf78836ed3b5a750262df39ac3412a4d558" => :mojave
    sha256 "b9d0ca5dd04aa35746de09d329535fcc2d5ccb4d86fe7a31620b7d7c9610a3e8" => :high_sierra
    sha256 "50f2d2986169ebf683e8704d3a0d63d4babaa568ae602fc81eecffe026220dd0" => :sierra
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
