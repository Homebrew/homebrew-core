class Gradio < Formula
  desc "Gradio is a GTK3 app for finding and listening to internet radio stations"
  homepage "https://github.com/haecker-felix/Gradio"
  url "https://github.com/haecker-felix/Gradio/archive/v7.1.tar.gz"
  sha256 "7b350583124f00f9030daaf4042cd54c9d340d67124dad298266d2dfa81ba766"
  head "https://github.com/haecker-felix/Gradio.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gettext" => :build
  depends_on "python"
  depends_on "gtk+3"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "json-glib"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "gst-libav" => :recommended
  depends_on "sqlite"
  depends_on "cairo"

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
