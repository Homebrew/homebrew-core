class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.8/aravis-0.8.9.tar.xz"
  sha256 "93609486489d5486e21620b1e6a939379b575d8693db5ccf89310cc7f399e0e6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "4bba35d25955610af5882f0f0e55cb94802ca2aeab130526f6f616913c6a7014"
    sha256 big_sur:       "783bf5f12506cd88805f7b39ca9c76ab06851b5ec7773bc175fdd974b6dc0072"
    sha256 catalina:      "c273e6e9fdab70cb738591c4de3f616c36c5e498339ccbce6260035572c1d27c"
    sha256 mojave:        "af8eee21f62279344fc949de35671ffca4d6afc3d04e6813095671176b1d484d"
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
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.dylib")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
