class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.16/aravis-0.8.16.tar.xz"
  sha256 "b3aec0d008e5ebb736f958f8b711a63e6bf802afe1c074a895818abe93d04f37"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "65cf84deeadce0e43513047d0118a365874617d35a2e072db0905cdac6950d63"
    sha256 big_sur:       "f99d59b92cc3185f1eaaf4a020edad6492ca05222c7dcddfd74bcf56a48b44ed"
    sha256 catalina:      "9c597f9451b95c127964022d5292c21a77a2767538ca69f432c39be98e76556c"
    sha256 mojave:        "09858bad9aaf22dfd7e7ec39ab56a17dd2d5b2441a5f7e036b21fb9b79994e34"
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
    assert_match(/Description *Aravis Video Source/, output)
  end
end
