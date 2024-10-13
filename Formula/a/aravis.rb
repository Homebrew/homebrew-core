class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://github.com/AravisProject/aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.33/aravis-0.8.33.tar.xz"
  sha256 "3c4409a12ea70bba4de25e5b08c777112de854bc801896594f2cb6f8c2bd6fbc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia:  "96d182a7e33a41f832f692201bc0bf29067db30a48d7039c0b514c076e9b205b"
    sha256 arm64_sonoma:   "e39510f09d4f2bda766c23e3f422d3040ee1225c5b8eddb8703b1318002484de"
    sha256 arm64_ventura:  "d6313e2de688f3c43580f82848e2a6a47aa382491867ceceaccfaf6f133caaea"
    sha256 arm64_monterey: "5574d293684a538839a1bf15949a0bda46905721e93718e8d04939734778d58b"
    sha256 sonoma:         "2d5a187f29378ede5b3a2ea444ec088a58eb5f6e07a57d4bfdcd932cf931ae78"
    sha256 ventura:        "5cb47f331e3d1a275fcf322085393bbbd487195439f167015c869b43e815825f"
    sha256 monterey:       "082d64d606cba9a7915f7cdb07cd82358e01b5f1ea50ce99fbd18fea6b403295"
    sha256 x86_64_linux:   "61d4079388a76864b9d039db61907ed2f9ba32f08570bbac330e03bcf936334f"
  end

  depends_on "gettext" => :build
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
    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
