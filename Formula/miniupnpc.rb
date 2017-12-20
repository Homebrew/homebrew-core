class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20171212.tar.gz"
  sha256 "cef135ae46c12358a485e809619c01145238aceb10e6e8e2946ae40c4dbe477d"

  bottle do
    cellar :any
    sha256 "3de29a59503819d36e95f14bb1bb769791392012ea41b82ca6addd5a8792df4f" => :high_sierra
    sha256 "eb4f9b951de3486a934a1cd63774bbf95f09040403914f211b056353741d6837" => :sierra
    sha256 "06cda8bdcbd17cc5d1e15e0c4a6b0a2fd2a7708f94908cbca87616926b42b87a" => :el_capitan
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
