class Gradio < Formula
  desc "GTK3 app for finding and listening to internet radio stations"
  homepage "https://github.com/haecker-felix/Gradio"
  url "https://github.com/haecker-felix/Gradio/archive/v7.2.tar.gz"
  sha256 "5a85d7d4afb1424e46c935114b268e4a65de2629d60f48eccd75d67ff4b113d2"
  revision 1

  bottle do
    sha256 "fc72163c4714998d62ff4e51494e81fa6462677d99cb496a75f2b3c7fda0e5e3" => :mojave
    sha256 "bc283cabff48ef33c8236e5bf308955fb06eae498f4c1633e6d50ac1ac29f029" => :high_sierra
    sha256 "0681cb3d462521ea07ae53cc57ad83af345150916ea4302f0d9a2266ae93d746" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gst-libav"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "python"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gradio", "-h"
  end
end
