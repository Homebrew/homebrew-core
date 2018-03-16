class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.7.4/corebird-1.7.4.tar.xz"
  sha256 "7c53a356eded58eca423128b28685107a11d3f7bb0a08e0fc072b60c2b0f0041"
  revision 1

  bottle do
    sha256 "37bd08a19a29cf0ffca6cd01ccfa936fd5b73b96f5510b17f7d025ea8f322c71" => :high_sierra
    sha256 "5311c5ce2664e7f4887e7354f5df9f0dc5cca05c8159ff888e98bd05a5e62efa" => :sierra
    sha256 "c19d2c2ff23b10da55d37faae3607929452f20c78e9b8c093abbae2c9f1954d2" => :el_capitan
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
