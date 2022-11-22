class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.22/aravis-0.8.22.tar.xz"
  sha256 "8cdad1e338f3faad12886dc71d61d882a15a58981a153831773da6713d1ff920"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "a228f73aa58f4472a371c70f9c64b2b4d65792ebc7be1fad5b8281d015e383ce"
    sha256 arm64_monterey: "01de5ba5556bf268d71cca75711dc4c698c40b1d9fffe4cc4a7885eb1adb2c10"
    sha256 arm64_big_sur:  "d2fa5781b57ee6332cc6f678369d25a4d26d6f579afac2f9875e42e045a13984"
    sha256 ventura:        "c3ba500b92aba703f1edd829bcaeccb7e188afa368ec0cb120daddb2f888d8f3"
    sha256 monterey:       "dfa5542aed3674193dc577688156dc226d647fbcff828421504f6264d43f0108"
    sha256 big_sur:        "802ecc915a61af9b7933efea0cb0db3ae7db633decceb6ab898550c2db3be7af"
    sha256 catalina:       "a2ce71068e705a49d9a3e728729f2c1d947bf90b45e2b2893d007309c3db4780"
    sha256 x86_64_linux:   "b688844831dd62df8460541a5edd385f5f0fad188d21ac04da02df16c71c2ea8"
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
