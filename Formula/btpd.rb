class Btpd < Formula
  desc "BitTorrent Protocol Daemon"
  homepage "https://github.com/btpd/btpd"
  url "https://github.com/downloads/btpd/btpd/btpd-0.16.tar.gz"
  sha256 "296bdb718eaba9ca938bee56f0976622006c956980ab7fc7a339530d88f51eb8"
  revision 2

  bottle do
    cellar :any
    sha256 "0b479e7b812055a0ebbbae40c63624258044d74cb11a2d698392792a5b543e4d" => :mojave
    sha256 "35042eba57182babbaff9f4a2eb1cbe891ebd82d2427a14926fd3617475da363" => :high_sierra
    sha256 "6951afbf4af1e9d0df95f5d9260ef04eeb7e558cd2d58c3a429a99ad93c2dddc" => :sierra
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
