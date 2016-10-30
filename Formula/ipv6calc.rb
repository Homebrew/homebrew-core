class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "http://www.deepspace6.net/projects/ipv6calc.html"
  url "ftp://ftp.deepspace6.net/pub/ds6/sources/ipv6calc/ipv6calc-0.94.1.tar.gz"
  sha256 "3bd73fd92c1d971fadea41b39830975b4a20bbcd26587dfb2835964b33de4040"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ccbbf74bb739f03f508b3b9de284a976deb6d812b162ee8993950537503ca18" => :sierra
    sha256 "437b1ccd14d570eed3f5aefc6136921fecf64a6e5271342b56f265436562f610" => :el_capitan
    sha256 "07aaa189403bd9d01a12e5aa79e8447e6f182cc6ef1ddcd68d5a9588cd6dd435" => :yosemite
    sha256 "7b3518dc5a1a0e9d8804b2d3e231b271f112569f61ae816f3649ca2ba55b9168" => :mavericks
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
