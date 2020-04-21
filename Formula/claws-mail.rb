class ClawsMail < Formula
  desc "The user-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.17.5.tar.gz"
  sha256 "f79e4c7f089d08e6b2b3323a90b6f46991a154ce168ba4a829d593b7a5768c7b"

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libetpan"

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
