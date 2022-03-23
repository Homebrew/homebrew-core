class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.21/aravis-0.8.21.tar.xz"
  sha256 "3c4f768b22e7333386fc2622ef731722cb42971de1810caa59d29aa23eedff39"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "aa2eaf08418a757ff9674b3a2d608226cd239ae0b6bbd5fe83e28484692d8543"
    sha256 arm64_big_sur:  "b82f4f316c018f8a0da981d45e8c4dacc2923aa575a845a8fd1671b321dd6a13"
    sha256 monterey:       "6672015ed4c930840fb9d7c89ffc6f873853efa544e58026a86f3844866af341"
    sha256 big_sur:        "719eb5e48b95b6a9af15d3f79339d010a6fac4636b6f8809992c20709cd90184"
    sha256 catalina:       "9be5b6ee68098f84d6a45230bbad518c58d6fff1fe5b3eef2aef8abeee139a62"
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
