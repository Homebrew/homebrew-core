class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.1.tar.gz"
  sha256 "e19fb5e01ea5a707e2a8cb96f537fbd9f3a913d53d804a3265e3aeab3d2064c6"

  bottle do
    cellar :any
    sha256 "f21e3e05b3e4fc1f77faf9dd8b61669e8869aba271cdc07361ba5277ca0b1f25" => :high_sierra
    sha256 "a12cb322b102517520c337337238cc45dc6f76f912053bbb72a3019dbc8f3ff0" => :sierra
    sha256 "f7205d28da37499602b1ce6cb44f854352b168d999f7091e324dc09b6dd4a733" => :el_capitan
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
