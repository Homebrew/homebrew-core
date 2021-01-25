class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.8/aravis-0.8.5.tar.xz"
  sha256 "b44a48069476bdf20de71b09c96cc009bf5bc0d200181e56317df94201375e4e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "218ce79f2236b26add2e63a08d8c9a9e84602d529721961314d7e4983bda2876" => :big_sur
    sha256 "59472780fd24166c9699d3fb41a7365f947124a41b4a047975dcadda734762cf" => :arm64_big_sur
    sha256 "56df75d6751653be613443afe383d4a48baa2b5ab3a6afe3aa14552b0fc3304b" => :catalina
    sha256 "e146837e4fc78e8aa7af2298547862ec0beb20dcdd229cceae503f6996928b21" => :mojave
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
    assert_match /Description *Aravis Video Source/, output
  end
end
