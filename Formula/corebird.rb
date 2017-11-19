class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.7.3/corebird-1.7.3.tar.xz"
  sha256 "cbf42fdf186f5dea47c5d171f6a6dd47a05d0e721a4bfd6e61b53069ea278e27"

  bottle do
    sha256 "bc2169cc467559989431bb269bb66f0ca89014aa715ff61760bc9b9feef2968d" => :high_sierra
    sha256 "2e0ae1a82319709f7ee6dbcb51217b4d4ce88e723b39070cbf6cb3ade1c0831a" => :sierra
    sha256 "e4315fb5a33c037c0dc0da9c605dbce97e296ebc465bbf6c6ea37d45a00fe3f4" => :el_capitan
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
