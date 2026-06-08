class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.4.0.tar.gz"
  sha256 "642d78309b7b153699c417bcfdf505a735b19c57fd731a0bbb5752ad6adbdb52"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6a878ec617cbc06ea46266d580dd8b3508438e1e924ca02ec0828df7b9f83380"
    sha256 arm64_sequoia: "e135ce5024f49f22585e9c388dd622ef0a7d4c194c14ad8adcdf55e29aa083ed"
    sha256 arm64_sonoma:  "8adca7bbd343d0955d024556b37c934a6b8a1d2099df6f85966c9e895bcfaa11"
    sha256 sonoma:        "c60374748a22d96da117d767f0af7da4f776fb47ec8f06142dad96399fdd43b1"
    sha256 arm64_linux:   "8a2dd1c7bdd3565ef1682a6af2ea84718efc7f194c73a8d60e718a2959ed1a16"
    sha256 x86_64_linux:  "dde25b7da8bfaaf8dffd7ff41687c806637349e59a08caf43f30e772e4687ccc"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libetpan"
  depends_on "nettle"
  depends_on "openssl@3"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libice"
    depends_on "libsm"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-archive-plugin",
                          "--disable-dillo-plugin",
                          "--disable-notification-plugin",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal ".claws-mail", shell_output("#{bin}/claws-mail --config-dir").strip
  end
end
