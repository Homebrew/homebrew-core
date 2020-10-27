class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.17.8.tar.gz"
  sha256 "50d40789d33063c16b38b4177be88ffb1d499e75007e8630670996fa2cb25f20"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "291bdf8b3f542711d06f2c7d0fd0dab69fad2afc20dc82bda031e7908c1e6073" => :catalina
    sha256 "54067161cc3de3a740c0307ddbe49d127ca7855a5857d54baa25e60ed9942cbf" => :mojave
    sha256 "1ea18b8c1903d458fc080ef53738549d6f197b86c4501e0f4bfe779ad51a5ba6" => :high_sierra
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
