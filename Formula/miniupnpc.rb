class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20171102.tar.gz"
  sha256 "148517020581260c8a2fa532224870bc53e59004777affcaf27ef636a72825d4"

  bottle do
    cellar :any
    sha256 "9ba3a1049df7fc38dd89dcf0b759e581cc05a57438fe1196e155ac9122410042" => :high_sierra
    sha256 "9159572f5d3d5a508829b7800e7ef828f490e979472e8943ec4c0cf6d633b77d" => :sierra
    sha256 "3b718e068ea3a952a3acf9a58b61a46f3fd7ebccb10f1d092f07d189f9b7dca9" => :el_capitan
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
