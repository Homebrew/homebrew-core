class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20170509.tar.gz"
  sha256 "d3c368627f5cdfb66d3ebd64ca39ba54d6ff14a61966dbecb8dd296b7039f16a"

  bottle do
    cellar :any
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
