class Gradio < Formula
  desc "GTK3 app for finding and listening to internet radio stations"
  homepage "https://github.com/haecker-felix/Gradio"
  url "https://github.com/haecker-felix/Gradio/archive/v7.2.tar.gz"
  sha256 "5a85d7d4afb1424e46c935114b268e4a65de2629d60f48eccd75d67ff4b113d2"

  bottle do
    sha256 "6dbf39c1065e7b56c72d503e873fa09f1ae7e39d4954b0c535709a9b7011ed30" => :mojave
    sha256 "3d0c607e60a10c4d4cf747582a2a9e31c4e79cc6da43f8203bfd3394e2d82588" => :high_sierra
    sha256 "3538e5558fcda654089ae4db90a1ce7fe9c59d4e8bbd8ca9324f925ae1f316cb" => :sierra
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
