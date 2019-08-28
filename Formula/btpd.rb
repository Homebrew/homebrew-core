class Btpd < Formula
  desc "BitTorrent Protocol Daemon"
  homepage "https://github.com/btpd/btpd"
  url "https://github.com/downloads/btpd/btpd/btpd-0.16.tar.gz"
  sha256 "296bdb718eaba9ca938bee56f0976622006c956980ab7fc7a339530d88f51eb8"
  revision 2

  bottle do
    cellar :any
    sha256 "6957aac8c38ccf8faa140f961de205bcd1bf7e7ee3dd68ae545dd0b94d16da19" => :mojave
    sha256 "81d4cb1f1407e4619120e6551258888fc7266ab1d98968095fbbef76e80d1f42" => :high_sierra
    sha256 "c951cbaadc8a4a04dbe95fe28fdb6f2ad760352c58fba5a36309ed3fdff69e16" => :sierra
    sha256 "4dce615bca726cf8ea3adfd0ab5e18f4f1e3d95d1a4d98ce38d6f894b1206a25" => :el_capitan
    sha256 "382f8e3ec6e514f5a5116b562c82e0f3b2ae786b625ba08ab222fe7db9a4bcff" => :yosemite
    sha256 "62a5bcf9db33b7b543053ce0a7d6ce4ed1fdfc43c9fca2500adc289c8bf34dc8" => :mavericks
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /Torrents can be specified/, pipe_output("#{bin}/btcli --help 2>&1")
  end
end
