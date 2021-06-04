class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.8/aravis-0.8.10.tar.xz"
  sha256 "4ac9e121788e587383aeff6ee360970aeb9f4fb2fb0c3fc978c4ac24c1cb4b84"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "8b2f656a4daa8f6d9fb07be93bb5f18ff9981d6206badc28085de83cbe514d10"
    sha256 big_sur:       "fd8fd9185cd33adb2ac511b17c2cf8f108301c5b523597b7ed96ed6203b9ed1a"
    sha256 catalina:      "70ceae18dae1f3ce585bd17c50520eb5740c6e325a6acae0da8de38684c5caae"
    sha256 mojave:        "a3c7c54c4115bdba963f55d7a16eef061161cea595dd20967ed5040e3aabd2a3"
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
