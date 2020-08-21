class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.8/aravis-0.8.0.tar.xz"
  sha256 "e36cae575f2afdb416d56437baf8740717a59ef0364f79f33181e87762fe2dcf"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 "1bd9c1847561b56ca3f5298e9a48f2347548387d6a677e31905df4c455cddd5a" => :catalina
    sha256 "b851c3d06486230de2a79a57d82455029cb07890749e4525dc929a075cce1c70" => :mojave
    sha256 "948909cbf756dc510beff0d8bb88d31f49b8d335d637b260592dff29608939f6" => :high_sierra
    sha256 "b97fa0af26f27a4a7ff3f56b6e24b300199ad7f208343a431e8ea90a806a9d9c" => :sierra
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
