class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20180503.tar.gz"
  sha256 "b3a89368f1e661674c8453f1061eab6fdf4dc7374332961d273b37b9a2016937"

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
