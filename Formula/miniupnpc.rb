class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20180410.tar.gz"
  sha256 "0e4c6d6ebc8b75eb636df7d3f3370c98713545acc3694b5ae40daa2502487a23"

  bottle do
    cellar :any
    sha256 "1c0b7e56919ce59d6ef76e7804df53ef7b5923a6f67ec78a653e671b9478c532" => :high_sierra
    sha256 "835144ebca86307b1bb99e21440af2a7322eaa1add8d1035af5d795ea0fe509d" => :sierra
    sha256 "6d07c2529e80fdb4d3459be841ae533ec19e45aed8093f49dbd069ce3156c6b0" => :el_capitan
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
