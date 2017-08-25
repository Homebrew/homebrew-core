class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.6/corebird-1.6.tar.xz"
  sha256 "604ad690405b46c24e18968d40adb6aca49763d9fe2cad90b1741d83b46fe853"

  bottle do
    sha256 "787c77b73b7c34bc0b59ba74699483e65cf9b9a2f62f865fcf06406f23218821" => :sierra
    sha256 "17fff95b88b23ea7f2dec025b53692e344335ece07ab11982806e458d23c669d" => :el_capitan
    sha256 "1cfffdf6dba702e9d40933bb5058def94e9f2d0e6886e93488c6e4a47db6e093" => :yosemite
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
