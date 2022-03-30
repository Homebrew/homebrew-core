class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.7.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.7.tar.xz"
  sha256 "71627b14e26390f1e216047f40ca5ee1e7d55651667787466433bf7abdb6e317"
  license "BSD-3-Clause"
  head "http://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a840f83399674d45b45c29bd41cbaf6a901779e33226c83cc4d71e08cbc93ec6"
    sha256 arm64_big_sur:  "5139ccc0ee27332891de4634edccab4b74d39c0a65b9bac8034c4f76ae8dc8be"
    sha256 monterey:       "e91fcbf5d7cc3af521719f0172836dab56634f0f7a8c52854343d38151e11f04"
    sha256 big_sur:        "e34de29881ed577de6ffbc5fdec471f59707c4e6a91bce1f453656d93612c37f"
    sha256 catalina:       "882c365f9c32d24c729464e83b399a35d4620944bffc5732cc21bff52751836f"
    sha256 mojave:         "1ddec44e5b0af07dd5a434ebd913c7139a3270cb8bf6a0807eafca9795aa5dc0"
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
