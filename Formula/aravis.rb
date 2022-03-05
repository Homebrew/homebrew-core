class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.21/aravis-0.8.21.tar.xz"
  sha256 "3c4f768b22e7333386fc2622ef731722cb42971de1810caa59d29aa23eedff39"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "2208b800f086da816639d748248453eddcb2d7f85b311cb05a96ed611f848e56"
    sha256 arm64_big_sur:  "aee90cd98142cf3b96c0e0bad4fe8c12610c4f41ead1c0443596bc88c3acec56"
    sha256 monterey:       "364f6d689990e6cae629e1a01bd1d0689f4fe0d6b67e1de6cc370ca449e47928"
    sha256 big_sur:        "8ed3f87980bb7d8974008f3523b5904478d66b1efc17f331465f3123b2ba637f"
    sha256 catalina:       "bb1e49d6cb99b95531097fcc9ed030a509f170a007f3e247ccf8ad26d9f4d593"
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
