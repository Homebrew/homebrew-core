class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20170509.tar.gz"
  sha256 "d3c368627f5cdfb66d3ebd64ca39ba54d6ff14a61966dbecb8dd296b7039f16a"

  bottle do
    cellar :any
    sha256 "26ce335083a2a7b3c3f59ca42ca213c47c79cfe3f9b93d98bc36d695d5b845fb" => :sierra
    sha256 "3a9436ceedef5818b7ee069db2f83e7080d9bf721e25cf77c012a8d3013ae2d3" => :el_capitan
    sha256 "75507b0ea568402299cc5788d292df98da1887b76e16afc5f5db96aeb247554b" => :yosemite
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
