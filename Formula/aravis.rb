class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.8/aravis-0.8.8.tar.xz"
  sha256 "1fa85396b4a63d765fc201902934813fa8bbb28b504c8a009ffde405ed559da6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "a3d1b24b50c30741d55438a4cffcffc8135402b4be1dc0e9f6cd9f2d65931752"
    sha256 big_sur:       "fefb5c863c3703b69ef29933554c75e5fabfd7421b6608319ffa740e4d742a42"
    sha256 catalina:      "84baa6f24965396f6fdd28c9730e748593d464ebc182edd63188972523c2ee48"
    sha256 mojave:        "c0d5530ce3d427a267ccd725693a2301c958fbbfa953a351ae9c386d14168eac"
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
