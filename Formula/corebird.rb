class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.7.3/corebird-1.7.3.tar.xz"
  sha256 "cbf42fdf186f5dea47c5d171f6a6dd47a05d0e721a4bfd6e61b53069ea278e27"

  bottle do
    sha256 "a291652e056fbea798efa8692f9c103417a63108a67e6413e8b0670b77ae4a57" => :high_sierra
    sha256 "31a125c90a27b72c1cec482ad77ae12d39bc68a7b13ae29e3439b315056bf12d" => :sierra
    sha256 "36a8e50b372c3b11d2ff8654b834bd7d62a04a74c54527c10a8e07b78c329286" => :el_capitan
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
