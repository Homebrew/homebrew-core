class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.8/aravis-0.8.2.tar.xz"
  sha256 "6b2a9624f6374748873bca48d40c282f443a60cb80449edf9ef794a388ad277a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "72cbc1966b47715e25f00619707a13cf4491ad6971bb78c42d7cb85cea9f8839" => :catalina
    sha256 "3295cb951139ad196f9f2e82bf154bc8910d2deb42b805304d91964babc49ab2" => :mojave
    sha256 "eaf4ae2f445cba07e1dbff76de34753d49c5e2cd1d18a44804bcb5f6829af8c4" => :high_sierra
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
