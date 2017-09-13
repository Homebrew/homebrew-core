class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.6/corebird-1.6.tar.xz"
  sha256 "604ad690405b46c24e18968d40adb6aca49763d9fe2cad90b1741d83b46fe853"

  bottle do
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
