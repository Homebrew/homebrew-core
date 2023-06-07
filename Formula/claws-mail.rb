class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.19.0.tar.gz"
  sha256 "3feef9ff72b15fb9f1ecc5102d7dfbb5b1c2c53172d331a3fb453645a6b53a6b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "dfc013fe205c3e9e485ff23e2e41782df497ace6312a0ace48e05639be9a9f61"
    sha256 arm64_monterey: "74b9d0de5a9b8500e2a71ee118bcb5cd72a7901639ff1bccb3f2bcb633362de7"
    sha256 arm64_big_sur:  "00d742baadda6934b41f056e76741da56021a70f405169d91cfae04cf2052cf6"
    sha256 ventura:        "4e233006854352a4a518004a42acef004ad4af820cf4c04406fbe6e100e79762"
    sha256 monterey:       "f6a71dae91ade0eb99d4ec6b9aeca45c7c9e67a98ecd25b7618ba82ddf152685"
    sha256 big_sur:        "ff579b37e2968ffc54055e5d8fdc2cd07af57cb26859b4cda388ab4f83597a3b"
    sha256 catalina:       "fc87978da74bb95b34c5ab7a2a01c478be7087e49f46549c55c3908aa8371623"
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
