class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.7.1/corebird-1.7.1.tar.xz"
  sha256 "8a4760d5357b40ec8c71c8b3812f75a8515022843b91d3431fc1f0a66a517fc7"

  bottle do
    sha256 "ec32ea3b6d8b400b04958307f0c3cca28c20cc0030464ea7d50323cafc8de200" => :high_sierra
    sha256 "9e5d3a0bec0d58044b35eafc2a6434440c7a88d8f6fdcb8498e60737fbb0ab79" => :sierra
    sha256 "0f56d671657ca272fe9a4ffab69e7c4e8f8fb9de74aacf3a3230cee00c973085" => :el_capitan
    sha256 "7f735dbdb4262c8c11ea67ff8de771eb1e4f4dfa3391c42c4904a41732a38b56" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "librest"
  depends_on "libsoup"
  depends_on "json-glib"
  depends_on "gspell"
  depends_on "gst-plugins-good"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-libav"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/corebird", "--help"
  end
end
