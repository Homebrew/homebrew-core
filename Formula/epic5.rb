class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.5.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.5.tar.xz"
  sha256 "7ca53b9d266fa1b7ba7a1f68a23e65c57b1a89b94bce1a0ea56fafa7d6298cb4"
  license "BSD-3-Clause"
  head "http://git.epicsol.org/epic5.git"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5bb21db35131a0fde56142e748c958d42b425c864739fa1707be11d7e7f39bdb"
    sha256 big_sur:       "5aba4e571c8827f29799b6d74f7b21eeb722bd1e8a5527c77c1ac482f448ae8f"
    sha256 catalina:      "101619ba687707c62ad66e26bc6a5c607996ca18146730bea9a6367ac9eaeb75"
    sha256 mojave:        "33233d7cd4cbadfb333079083a746791797402df481411568b99c874582fd440"
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
