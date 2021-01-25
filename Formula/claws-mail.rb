class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.17.8.tar.gz"
  sha256 "50d40789d33063c16b38b4177be88ffb1d499e75007e8630670996fa2cb25f20"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 "cc9a93ec8f3322edcd9c9be0a3c9b059d130008115e19276533675432cae1c67" => :big_sur
    sha256 "bbd1c67af463fb0645306523ebe20d37833aa8e3d38c042e8ce60d378c53d1d0" => :arm64_big_sur
    sha256 "5a559644851d9b007a6a500ae15558c5193c6e333cbe6c04f0294d03928d789e" => :catalina
    sha256 "f94aacf80c700939dbd023899421a2bd961d78ce3a9f958cc9156234ba92b150" => :mojave
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
