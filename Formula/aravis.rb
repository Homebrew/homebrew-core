class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.18/aravis-0.8.18.tar.xz"
  sha256 "57730381924db0ae37315f9d3b477dcddcda2da95300acc81c3590a04e37dfaa"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "7857c020f22ab970e185ac5cd57a23ded82540e6b8269a9dd6750f0b710ca37f"
    sha256 big_sur:       "b208cdd6a098a59741774507fd46df810f4cd7a672f65c6b42e443d2923b4ff0"
    sha256 catalina:      "7ae2a3d60536f3fbfa60b8b9a94ec0acc0b013636693741c1d0049024a9f2669"
    sha256 mojave:        "877a90a9ee943d80bb7bd26fee7278a0f80e72d9a393dd9ba71effc4108ed96d"
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
