class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://github.com/AravisProject/aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.36/aravis-0.8.36.tar.xz"
  sha256 "246deaa0042a387ff1bc00332d0fb80537ce14abde2c28d1a54c91f17adc51bf"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "ec4e6e6006fd2bd55fc2c88a2318fccafdea3ada23f6d7e4e4b1ebb4465b660f"
    sha256 arm64_sequoia: "a8d4bd460bfa0d913b71792959d5e5a95ccc5794264b1171e67eb90f1c80b18e"
    sha256 arm64_sonoma:  "0339abdd5f408a8eba88430494a3ebaa40e72e8877cc710be6c8cc1282430e9f"
    sha256 sonoma:        "e019edb2783c6d1ccaa2ba4d9ebc36697565bafbfba45caf6b936f13d69b0f40"
    sha256 arm64_linux:   "60c037bfb1d513b7120abb53716abc1a05d59ee7c91662cb2cfa5486caf29321"
    sha256 x86_64_linux:  "bfca87730aad222743588257dd29c5a17d8d86f88540bd69f175cc0ef704baa6"
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

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
