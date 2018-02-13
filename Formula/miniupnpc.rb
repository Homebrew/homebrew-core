class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20180203.tar.gz"
  sha256 "90dda8c7563ca6cd4a83e23b3c66dbbea89603a1675bfdb852897c2c9cc220b7"

  bottle do
    cellar :any
    sha256 "9257bd89a0790bb878ee24980ca273a16cbfded8aa2526b8529ea244dcce6ac9" => :high_sierra
    sha256 "ebc5201204aa7e6d8eadeb453c33998e62889263f2b6d9401855b0d6667b4c21" => :sierra
    sha256 "92482050397214509f9a14c2d8815d8d9b84eb0715f077535bdcb3dda1a4cab3" => :el_capitan
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
