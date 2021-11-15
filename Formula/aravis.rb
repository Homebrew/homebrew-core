class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.19/aravis-0.8.19.tar.xz"
  sha256 "ddadf4fcc253ca2d8eb765f6a365f2d5dbcff9cd7a431b07eb978dff3b9b1034"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "2047b9a3a794be7ae3afef1800daadd1ddfad7e11a7465cc29672ce796009339"
    sha256 big_sur:       "00cd392be23341574c6f8a32346ef30f66a626804a7c0a27fc030f0c222ab0db"
    sha256 catalina:      "c2861af12ed60af750bc91a8d2e13ca64f47d93731cf3e813d4b3800a5e73a96"
    sha256 mojave:        "fc11845a4c5fbee43f2eb52a715debfaa8796ad11012d269a2f6a4c39a062894"
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
