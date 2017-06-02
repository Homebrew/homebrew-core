class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.5/corebird-1.5.tar.xz"
  sha256 "6414668383c08f3a4bbb83da61ec4643ee7dd0470f60bac26f1e65771f03f7e1"

  bottle do
    sha256 "1d1a8de6fdf0bb1eed7bfa24398e43247ee1f06b007c33fe79815fb2082ff7f7" => :sierra
    sha256 "2e1d1a7cd09f385805d0672e9a1b7e211c4778b0b711e5b3095418442c36ac13" => :el_capitan
    sha256 "b20316807a544dee5cce001624260d3a0faa14dcba857704c0aa8842d203f5a3" => :yosemite
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
