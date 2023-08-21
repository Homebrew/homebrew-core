class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.29/aravis-0.8.29.tar.xz"
  sha256 "12e5f2f0e1a966c3a6dce0a42d96b2f24497f42ae6051d6f026811124e986963"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "21ffa0efe8c6bda8c5a6a981b070082d277a68dfe002a27adf2436fe6dc8a0c5"
    sha256 arm64_monterey: "7ff5a8f7e8afc162163c3018e18998672d820309764c63b7a6257f8e68b09474"
    sha256 arm64_big_sur:  "79a84f181912afcaa4954999216d8a1f294898ccae419858698020bbd36001ff"
    sha256 ventura:        "0a808a780f9a334fdad53cfc4b8ff02fc1ebaa0b0ae01369b8bcd6fb33453e13"
    sha256 monterey:       "9b171685c68d560e6cade4b9170a616a4176c236c8e2b861bea8a336cde1d8f0"
    sha256 big_sur:        "7c3643e2bf32f59c4693738b148b6475a76acd7bbec35c60d2b7372876c30522"
    sha256 x86_64_linux:   "b25da26d69c4deb447253395f0b8c5dfe20abee85df7c36a0619aa6c78ac3a42"
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
