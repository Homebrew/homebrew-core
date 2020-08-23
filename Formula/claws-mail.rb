class ClawsMail < Formula
  desc "The user-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.17.6.tar.gz"
  sha256 "8577673a8c238dc5c4481ca2b10373907995a340d3b8826f77b598601afadc70"

  bottle do
    sha256 "eab9985ac951a1e4f34b50c8bd1958a750ff3d7340927ae3df5918c65bb7ca98" => :catalina
    sha256 "29e33f59611554615ea37a1954445a8b8ad6290cbb344c7039512fd60197580a" => :mojave
    sha256 "7cf466e982da9464c1393e1d8e3bb0610581423639358466b265db6acadc2b23" => :high_sierra
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
