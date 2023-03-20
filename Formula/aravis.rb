class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.26/aravis-0.8.26.tar.xz"
  sha256 "cb866cbcf4de2ab8fedf5d6a1213dd714347adf25d9e1812df2283230f065f80"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "7b8539b5c6715fbe5e1c1190729a0cafcd8c7ad2b68f9b2de3a367d2888d96a4"
    sha256 arm64_monterey: "f1b8c71965cc30d5a0e67b74cd4e413c08f43524ee3c085947ab6f4e23dbc914"
    sha256 arm64_big_sur:  "92c03d273363efbeddd1718d304fda597f7a90bec40ddf9841bd5b8e98e9b37b"
    sha256 ventura:        "7c0ee991c488b3e8b47cbf0931f6da3498af1c4c9b1bc2da7aaf2e05ee2d5a29"
    sha256 monterey:       "c1cbe8f7c81f5e6129b13939c61318769db6a5bcaa96062daee10ac2abd2e91b"
    sha256 big_sur:        "058cf7af98f1f5b12398e7783e5fd8e0b5790e6e564af83c7b77b2e1a5a2c3cd"
    sha256 x86_64_linux:   "191211b85ea19f09472092668492e9ba9b83979c79b2f2bb22e12b197ef63489"
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
    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
