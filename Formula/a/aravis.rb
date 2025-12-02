class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://github.com/AravisProject/aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.35/aravis-0.8.35.tar.xz"
  sha256 "8089af991fc3a2644ab04b2ddf82623cd663d80c7ebbdefa93ddbc17ea702ddb"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "7fe8be556a8f02a85766e1a148332a4e3678a43ef0cd7c06c868586c3c8b9c07"
    sha256 arm64_sequoia: "b6b5d59f63c6bfed5c8f866727a7ccac618f5b92f72f473907131a959edc23a8"
    sha256 arm64_sonoma:  "4084af3b77b0bbc55f57af732268f933564cbff334c57c0c998b1ccf7118e320"
    sha256 sonoma:        "94645a9618b5671491ffa808933288e6d834284b3f045013037c9bc2cb0bff6b"
    sha256 arm64_linux:   "e90055c1c55ea0595360ffbb6e3f8c03ed2db4486f435ecee2775b26ebb29d19"
    sha256 x86_64_linux:  "86e3711d972075a1494aa2f8e86b1c9a71c85045a43cf4459fd84d02b00e66e5"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

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
    # The initial plugin load takes a long time without extra permissions on
    # macOS, which frequently causes the slower Intel macOS runners to time out.
    #
    # Ref: https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/1119
    ENV["GST_PLUGIN_SYSTEM_PATH"] = testpath if OS.mac? && Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
