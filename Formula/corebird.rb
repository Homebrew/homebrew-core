class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.7.1/corebird-1.7.1.tar.xz"
  sha256 "8a4760d5357b40ec8c71c8b3812f75a8515022843b91d3431fc1f0a66a517fc7"

  bottle do
    sha256 "741ea82815a619c1e714877802d0c6c1f6714a22771e1d2a209feaa8e83a181e" => :high_sierra
    sha256 "809021f13a5bb26b6684387781bcdfed6ac30492233b072aa559e828929bb312" => :sierra
    sha256 "5b37b3e8ecc2af10f8c806c6479087eadda5080b575c7b3905641302b568252c" => :el_capitan
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
