class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20171102.tar.gz"
  sha256 "148517020581260c8a2fa532224870bc53e59004777affcaf27ef636a72825d4"

  bottle do
    cellar :any
    sha256 "f451ae30090c9a8c019450ecebbad8bef497bdc21cbe1fc2b999c1f320b93d3d" => :high_sierra
    sha256 "491ca26ae7439d252143c5b08724a6497fc5cc8152b2b5d846509648040b5c81" => :sierra
    sha256 "f014f42bd47faa463bcb8ef6a2d28bc906523453405591aef062ed89e21844d5" => :el_capitan
    sha256 "374df29065f15c57469954527b5a7a185157a99a20b5d795659e83af4a20560d" => :yosemite
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
