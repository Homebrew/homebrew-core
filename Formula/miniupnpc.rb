class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20180406.tar.gz"
  sha256 "8c7226bd47a6e4a46ffa14b8cdef940a8a5c4f721ab33bc72a217371a4a72996"

  bottle do
    cellar :any
    sha256 "f0a408131f3affc4fbfe838d624dc9993ac9f33b13172d53cd36d3ed84ad2ab5" => :high_sierra
    sha256 "ab4234b5c43f6545de7a65f1f485811385b008aa8a3d7542012561f22b8e5801" => :sierra
    sha256 "a1b75e51819d03ebddca3784145bf32efbf41daf2a6f407fe11755eadbd9185a" => :el_capitan
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
