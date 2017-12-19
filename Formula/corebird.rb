class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.7.3/corebird-1.7.3.tar.xz"
  sha256 "cbf42fdf186f5dea47c5d171f6a6dd47a05d0e721a4bfd6e61b53069ea278e27"
  revision 2

  bottle do
    sha256 "0bd41e0af11458df0dff89a833d98e9850d868f5070196a6a87bdb121b55c554" => :high_sierra
    sha256 "b563160b12c8d7537e6850de74a389cc315880e261b7d7b41506e5ae9a7d75ac" => :sierra
    sha256 "f1b4b7645e96e335b92bb3f4c310b40e6295682e62b8fdc3bc7f19c068ab1656" => :el_capitan
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
