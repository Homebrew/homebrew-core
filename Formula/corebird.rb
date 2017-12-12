class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.7.3/corebird-1.7.3.tar.xz"
  sha256 "cbf42fdf186f5dea47c5d171f6a6dd47a05d0e721a4bfd6e61b53069ea278e27"
  revision 1

  bottle do
    sha256 "ddf44270a1faf2cac2cc505cfa2a19b9aa6d5c580a310b8562de0c8464c7c6c9" => :high_sierra
    sha256 "90aa8a76ec9dc8e79afd2d5bf9e55cc4655aa6027871ffa503586817948fd9ec" => :sierra
    sha256 "dc22516af05140a7dac0057475ea437c32e973bba13173df88c77febf36c224a" => :el_capitan
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
