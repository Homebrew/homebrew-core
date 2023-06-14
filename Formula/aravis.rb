class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.27/aravis-0.8.27.tar.xz"
  sha256 "30db6b03f2a49088746b8f709a690d6819a31ba3a95ad2131ffae6698bd11f55"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "a5614635c314ac3c71628882a0a1cfc067f32addb8c67f8625804c0ebb8632fa"
    sha256 arm64_monterey: "ef9fe6ce8007b693f6e6b3f57eec3a2db06b4eda4de83203c451fd4aefc1aea7"
    sha256 arm64_big_sur:  "fa445c11f63f753fdebd0317255460e20c1e802f1167d00e9a984c92c28f771c"
    sha256 ventura:        "89d2cf74f0d0c54f6507502372c678a514dd36427c751bd933e51f3fd0946784"
    sha256 monterey:       "7e83225c97981430f8b87c2d9bf171c6a08825b9bf4e7fb3fb7009ca11cb9017"
    sha256 big_sur:        "ab720d0976c4a97d2baace3c814255d5a462ac830e6021b34ea485db93f2d8d1"
    sha256 x86_64_linux:   "81eeffa0522b65381daa82bdff35a4ce99e5059ee5e7e2077c4e040dbdbf9b8b"
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
