class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.8/aravis-0.8.0.tar.xz"
  sha256 "e36cae575f2afdb416d56437baf8740717a59ef0364f79f33181e87762fe2dcf"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "604d55cc8bf4d12d598d6a306e75d38e3986202e6971838b42ec1e770a0cd8ed" => :catalina
    sha256 "083b7c5f1b7a4b7e068119ebd37858c891ada5148f5a8a41884cca286d8f8cdf" => :mojave
    sha256 "6bae8a3e91bc83a8f331da4ec5dabddaf3c877a835445f2ba92b2f80bd758fd5" => :high_sierra
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
