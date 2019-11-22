class Gradio < Formula
  desc "GTK3 app for finding and listening to internet radio stations"
  homepage "https://github.com/haecker-felix/Gradio"
  url "https://github.com/haecker-felix/Gradio/archive/v7.3.tar.gz"
  sha256 "5c5afed83fceb9a9f8bc7414b8a200128b3317ccf1ed50a0e7321ca15cf19412"

  bottle do
    sha256 "51fcbc324b7f1a95ce0b98c9382053d7f035db79f74f1d560f2a5452d2d081df" => :catalina
    sha256 "7d4f0372797621d23eb0e85f6d5ed2ae884703b57960c1586c09687d9d1055eb" => :mojave
    sha256 "5c3f745ad431c61ef3d19b4a2a03d6f24eb99dd47768178e6d1810edba4f12fa" => :high_sierra
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
