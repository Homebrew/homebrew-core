class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.26/aravis-0.8.26.tar.xz"
  sha256 "cb866cbcf4de2ab8fedf5d6a1213dd714347adf25d9e1812df2283230f065f80"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "9f657a5a59e310fda730e6e9f2db6aa0468269f1e3abce5c9c02b2fad655d429"
    sha256 arm64_monterey: "ddd783d0729912a53b0e81399f4a51682b77fa6fb33abb13b3c52e930850220d"
    sha256 arm64_big_sur:  "48e5efa2bbffd8a2fff4af276e664f8d270d73912ee791ab85533ec5a257584f"
    sha256 ventura:        "6489b5c0799136db0276806841f87b1f4d69508dc5c4accee636a7dbedae28e9"
    sha256 monterey:       "55818feb3907fbb78f965ba67458b1c2ccfd1653a68d5447ecdb544fd1801878"
    sha256 big_sur:        "f70efa75be67e6e0149404bce69cc252adc5177b70ce692247f9f04bda4c308b"
    sha256 x86_64_linux:   "e467f4494ffd91c4a54636f9dfe2be758aa0b724628b88ac47f7d322d122154b"
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
