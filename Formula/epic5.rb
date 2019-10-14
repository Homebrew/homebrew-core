class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.1.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.1.tar.xz"
  sha256 "81e18b5f6aa32c5c4b5d01d4cd94e3124b538e3ba42cf7dbb74a6f1f5081f9df"
  revision 1
  head "http://git.epicsol.org/epic5.git"

  bottle do
    sha256 "b0428f3aa116e87650ad8f0bf0f3a1c0cd78865da2a667edd95d203231843bf6" => :catalina
    sha256 "559a77deddf639f1b1e308c7a4bf41d54397c4b451c93fbf141304a0ff67acf3" => :mojave
    sha256 "d4fda821d78992e9cd7734ca8b2a05b573ed6c3330e691f0e548c1548596139f" => :high_sierra
    sha256 "5e7a528932d509348a38185b427c43ddfef3099a10eab52300d6fd7b9353b6f8" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
