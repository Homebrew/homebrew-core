class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20180406.tar.gz"
  sha256 "8c7226bd47a6e4a46ffa14b8cdef940a8a5c4f721ab33bc72a217371a4a72996"

  bottle do
    cellar :any
    sha256 "20fd08f703390e5705bf93ca96006f957588417f67ad051fd64abdb2c0ca98be" => :high_sierra
    sha256 "a94eccfb0774d3fbf4d6a283a71cf25fa99990724fa4c598fc7024c9134a5b0f" => :sierra
    sha256 "9e283eb9e30909a52c5334a68515336fe47d72a60869f89df9401cb879f116b4" => :el_capitan
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
