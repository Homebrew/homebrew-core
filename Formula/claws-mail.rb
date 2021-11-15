class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.18.0.tar.gz"
  sha256 "f107deec1f0debfae77f7f0022aef713f85a5b1f7d0b1a0e98f6eebe1e3556f2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5f1a0bc9c1950c7bf5169f927e7f0cc6895e43e6188dafc38a2cf1cbc029f9e4"
    sha256 arm64_big_sur:  "1e94b0baa4142502cd2f18e4bbdeafe3d73b7d0a5a6c13c16b5a74b6e49a908d"
    sha256 monterey:       "fe2336c158d68f1b821f1f625c0a2837c5708f84f4594140ec6bec2262b9e29f"
    sha256 big_sur:        "2c94ba339b902091781d9201c6cd71a2b9dfd401224317ac1f1368d17e44ee03"
    sha256 catalina:       "e1691b2e1a632759a0c4aef4167265af4edde36d777eb5bfce0310c3235f2b1d"
    sha256 mojave:         "b279ad0a5d167795deed2bdadafeea2f7fff4dca2b26c580a91c28cdaaa4b1c5"
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
