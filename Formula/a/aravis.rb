class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.31/aravis-0.8.31.tar.xz"
  sha256 "9c4ebe6273ed3abe466cb6ed8fa5c132bdd7e9a9298ca43fa0212c4311a084da"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "1f4c2e38ab288ea7d63f6819b98d7ed6360bc96084f42c3238e6a01cce42ccaf"
    sha256 arm64_ventura:  "37fe3ab86c269e0d29c3426caf4bde33fa9c0c6bc7a44cd9c9ccb74f1bb895aa"
    sha256 arm64_monterey: "d6aed1ef3322c79867426e8362e0e140c7a60f36d4c06d929fa5993a55cf7dca"
    sha256 sonoma:         "a9a529672a64eacb6a54ac796ec1e9e935d757b53badaeb5886e01b01daf6cce"
    sha256 ventura:        "2633a32ebb17ea6d140445a86d8b19d9561f8840efdd3f961776f0a31c0a5ea5"
    sha256 monterey:       "2c0315ba520f01d7b29cacc00504f9802d7ac9a8bff748a6d129fb7f0ed3d487"
    sha256 x86_64_linux:   "46efd141618e6c8d828da803918377263e2642a836b49d38f457c24a2d60ec49"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  def caveats
    <<~EOS
      For GStreamer to find the bundled plugin:
        export GST_PLUGIN_PATH=#{opt_lib}/gstreamer-1.0
    EOS
  end

  test do
    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
