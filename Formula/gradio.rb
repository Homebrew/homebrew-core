class Gradio < Formula
  desc "GTK3 app for finding and listening to internet radio stations"
  homepage "https://github.com/haecker-felix/Gradio"
  url "https://github.com/haecker-felix/Gradio/archive/v7.2.tar.gz"
  sha256 "5a85d7d4afb1424e46c935114b268e4a65de2629d60f48eccd75d67ff4b113d2"

  bottle do
    sha256 "28884996514f502e76f23eaae56e8dbcd9e6c1c894384c680f7270f571152ff9" => :mojave
    sha256 "54a1da06a3d61538adbf564a0676330e11e84b8e06e5c7c10ccf3e952d663b10" => :high_sierra
    sha256 "cc714c194d3bcdc8566ded85a06622b0d6d9f1a1866987588bc0f5015c24a72d" => :sierra
    sha256 "d493064dfa5b122cfff42d6fe697f7f6f65269e8bf9b562c7556dd9385af53ed" => :el_capitan
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
