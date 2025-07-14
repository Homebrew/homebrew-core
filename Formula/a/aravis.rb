class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://github.com/AravisProject/aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.35/aravis-0.8.35.tar.xz"
  sha256 "8089af991fc3a2644ab04b2ddf82623cd663d80c7ebbdefa93ddbc17ea702ddb"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "5dacbb067602cd6942321a0e548cdff50b237162f12819baf9f2ee34040aa3eb"
    sha256 arm64_sonoma:  "82e9c7e422b14826f80abac1b17a271ead738e5abf4fe862799d68aad848e803"
    sha256 arm64_ventura: "27e3c92eb7b96f192bf0e4d73a358088ada319fb8a10dab041e678d43b8472d9"
    sha256 sonoma:        "e0eca377a1cf2abfa292ca80b36627376e0bd2f28237876ce5f07cbb97428947"
    sha256 ventura:       "f08e8cc521c459783db474b8cd887947018393f33cc7eafbe9a00ac908b70b5c"
    sha256 arm64_linux:   "086dca0e9de5c8780bf98bf202808565b73ec26419f02b5a99fc2c67040329e1"
    sha256 x86_64_linux:  "50d18122eca4c3b85d4eb4f5fa4fb31d129ade755a4ef3bfde377cc64710814d"
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
