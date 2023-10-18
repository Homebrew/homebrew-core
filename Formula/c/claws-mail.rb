class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.19.1.tar.gz"
  sha256 "4fcc2b0b39a6d40e4dc3e49fac2f1cf063575d6570e93408fa4a76ab67531ae1"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "27556d5cbc7fe4ee270b90a3f6c0b04975d3be71374d87ae2648722be39c9dcd"
    sha256 arm64_ventura:  "5a319893dbb61fecce7527d7aa50c8498281c0db65b637401a850a30f4dc3566"
    sha256 arm64_monterey: "d859faed86f3da9fc93f51644fd5f330b021c3b387392935e303c356fe9152ec"
    sha256 sonoma:         "a0eb24fe0b25855cdebb845f9dd75a6da1a211057fabecd28f117c2a2a1a457b"
    sha256 ventura:        "ead29a0507893b238927b2fec984b4d0885ba6d062bd09d39ee224a63cb39780"
    sha256 monterey:       "6241c21eac60f1fe0078b60e53ef55e94600dbc75bbccae3b3a6a9ce3f58e97c"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libetpan"
  depends_on "nettle"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "LDFLAGS=-Wl,-framework -Wl,Security",
                          "--disable-archive-plugin",
                          "--disable-dillo-plugin",
                          "--disable-notification-plugin"
    system "make", "install"
  end

  test do
    assert_equal ".claws-mail", shell_output("#{bin}/claws-mail --config-dir").strip
  end
end
