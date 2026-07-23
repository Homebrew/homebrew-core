class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.4.0.tar.gz"
  sha256 "642d78309b7b153699c417bcfdf505a735b19c57fd731a0bbb5752ad6adbdb52"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "802a84e17c8e82c3b7794785d56f92e862c335c184525aa8437448e507e68ab0"
    sha256 arm64_sequoia: "5c4648384fea31d7c9ebe5116656e119b752ee0eddd86b3ad305fa4827d4c51d"
    sha256 arm64_sonoma:  "037137457f0cad56a06a0ac87bc003dd9a9f8120ec4585ce3093ce1e79e12d0c"
    sha256 sonoma:        "444debd26e80fa85dac3b1a5019ce26c2a22ee933be8a810c6454dd6d5c728d4"
    sha256 arm64_linux:   "117612a79662d6f2241bf6e14a5aa149af5d2b055e632643cdf7bdc399bac776"
    sha256 x86_64_linux:  "9cfb9bccb094e86849d6add6c7e6af8e6b621354963a9fda130cbcc6090547d6"
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
