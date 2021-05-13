class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.8/aravis-0.8.10.tar.xz"
  sha256 "4ac9e121788e587383aeff6ee360970aeb9f4fb2fb0c3fc978c4ac24c1cb4b84"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "2105e542ab2f6eca3805f6392a60fef1f407191c02acc8ae6c5f601687c28064"
    sha256 big_sur:       "fb12fb0ec8c9b797fb10de9f7168edcc3b036829c71ec3cc55c0743b3b83c32e"
    sha256 catalina:      "46abbbf6d8032ee22bcdd5dd98c72ed3e810b40c9f9af3eeb1ba5d569184f009"
    sha256 mojave:        "c396a80defb22b0c696b31e84a5bc63db8621fb4a419ecf8690cbca2c23d9ede"
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
