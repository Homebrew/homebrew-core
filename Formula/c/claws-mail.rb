class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.3.1.tar.gz"
  sha256 "8fc4f0e0f274297063e5e7682089a32b65ac1b2d21cfa13c54b980520952def2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "9ea4f72acf61a1201eb135faca0a0024c545f9f358ec35ee561d8a06d8f3e63d"
    sha256 arm64_sequoia: "e738cd1a1f4bb83dae0dc1cfa589c7162ae4128313ab79b403862748b8f3e02b"
    sha256 arm64_sonoma:  "741fecf147e4c031b0fc0cbe5ed732b7bb8865a40059d307c4292099ddda4403"
    sha256 sonoma:        "28e9f6b5dba651921e758033f4f4cb23aa08c05258293c64a7f72c0a9c97c0ef"
    sha256 arm64_linux:   "d4872867810e1204e5b432f1be4a6d124d1333f3ccf9b4f4eefb11b8540fa8dc"
    sha256 x86_64_linux:  "c2538ff144b8a628173be5ce98bb83b76d9082bd2d0fc6e0a68b073a4ea46f53"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libetpan"
  depends_on "nettle"
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
    if OS.mac?
      ENV["LIBETPAN_CFLAGS"] = "-I#{Formula["libetpan"].opt_include}"
      ENV["LIBETPAN_LIBS"] = "-F#{Formula["libetpan"].opt_frameworks} -framework libetpan"
    end
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
