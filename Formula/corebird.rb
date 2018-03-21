class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.7.4/corebird-1.7.4.tar.xz"
  sha256 "7c53a356eded58eca423128b28685107a11d3f7bb0a08e0fc072b60c2b0f0041"
  revision 2

  bottle do
    sha256 "a52e7fe27f0726138ba11ce89bb9c4e2e079fe0a5ea1d03d67739afdcf74955a" => :high_sierra
    sha256 "98a012c51a4691c53bd648f605fa527fe25f469d1ff149bcaef42714887bb440" => :sierra
    sha256 "573f418b19955f5b25e52eef4aa2664b236089a367e6ed0e58422be45827a3a6" => :el_capitan
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
