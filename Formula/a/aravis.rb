class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://github.com/AravisProject/aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.34/aravis-0.8.34.tar.xz"
  sha256 "2e43d0543088bfaa4a4493d3ebb83a14ec0597f4135a5ad45d2f90313fadf01a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "9503760055d6fe1d56de6cb2813ae97ccb81a3d8782c8cc1094f340d22049bb2"
    sha256 arm64_sonoma:  "003c937f9c73506c6395108366897f44b8add2ca8008da7a21384e43bb5cbb52"
    sha256 arm64_ventura: "0616473518e5f3803439912e0ed5f934729342aace2b4b9c6d41104a98396a08"
    sha256 sonoma:        "34be01100daa2aee86096d438473248c6874ed7e33cd70aa92a3193ceab1f3d2"
    sha256 ventura:       "b52ff39d38000c9c545ce5b182ee07371eecb39dc2e657f15084e6ea011c363c"
    sha256 arm64_linux:   "75495ecc6f59e629f6571ab02265a7f5e79934cf1f8e30253a2714f5b29498d0"
    sha256 x86_64_linux:  "c80a53885fdbd26fd1cf66bb5465d04c9e070b4d9da8eae1214d5bbf97b977af"
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
