class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.26/aravis-0.8.26.tar.xz"
  sha256 "cb866cbcf4de2ab8fedf5d6a1213dd714347adf25d9e1812df2283230f065f80"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "82eb96c6252e2b1e70fe9b674fc39039c29e88099619aa7e5ebf0bbaaf45e67d"
    sha256 arm64_monterey: "e78951e5a3b1796850c87b7f063caaeea7752ae41d14174b7d36932cc8b7325a"
    sha256 arm64_big_sur:  "e82e9a4a1a50e98d26f4d9b8995fb1b875aab4c579cfbe5b1e12436dfd88a0ee"
    sha256 ventura:        "b04b602a5369417202f6e1c58ae07d026076e204a9586b23abf961498081fe56"
    sha256 monterey:       "98b52d161ea00386e3430bd147df980262a44adc74ffacf105ca524b34b3d5c2"
    sha256 big_sur:        "4f9d5e6be023e7356b475c35a3a939fe1e86bf377d0aec3337422fc415bbf90c"
    sha256 x86_64_linux:   "96e081f2e5608a943e48eebc34f0f3137b73f8f99b3062330b70223fadcd3681"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
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
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
