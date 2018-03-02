class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.7.4/corebird-1.7.4.tar.xz"
  sha256 "7c53a356eded58eca423128b28685107a11d3f7bb0a08e0fc072b60c2b0f0041"

  bottle do
    sha256 "52b4c3c3383f9f5833a9bf402fecdf6f7838cbfca08bc515feb83eec42d7df9b" => :high_sierra
    sha256 "1d4cdd55d12bbd976df0c1e238383b11f47500b0b041d41e268c4ebe6c416ff2" => :sierra
    sha256 "e4e897f628712ec130b442654bc880fa1b6b1fcdf69b64b2b4d458d18f61106b" => :el_capitan
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
