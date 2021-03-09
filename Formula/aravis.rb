class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://download.gnome.org/sources/aravis/0.8/aravis-0.8.6.tar.xz"
  sha256 "f2460c8e44ba2e6e76f484568f7b93932040c1280131ecd715aafcba77cffdde"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "03957fe3eab53520827a52a153f527615cdbf07406636279891189f8b037c6fa"
    sha256 big_sur:       "13b501800640ac63a447119d9f82f1dabf26feeabfd119d8e559536bdb6723ec"
    sha256 catalina:      "21518b405685f7cf230f084570bc92b9fbf7ea116bbabd02041b4f265d2e762c"
    sha256 mojave:        "da90fdc84b7291acab730e63443b23c007f9f328a4a0f172bce50c054b3d76f8"
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
