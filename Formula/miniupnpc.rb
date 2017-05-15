class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.tar.gz"
  sha256 "d434ceb8986efbe199c5ca53f90ed53eab290b1e6d0530b717eb6fa49d61f93b"
  revision 1

  bottle do
    cellar :any
    sha256 "26ce335083a2a7b3c3f59ca42ca213c47c79cfe3f9b93d98bc36d695d5b845fb" => :sierra
    sha256 "3a9436ceedef5818b7ee069db2f83e7080d9bf721e25cf77c012a8d3013ae2d3" => :el_capitan
    sha256 "75507b0ea568402299cc5788d292df98da1887b76e16afc5f5db96aeb247554b" => :yosemite
  end

  # Patch for CVE-2017-8798. Due to upstream developing everything
  # within the same tree it doesn't apply cleanly from a repo patch.
  # https://github.com/miniupnp/miniupnp/commit/f0f1f4b22d6a98536377
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c6df018c/miniupnpc/CVE-2017-8798.diff"
    sha256 "0c75dfed81bb66118e3eb3d1764e229a24a196ca33f060896478a067037ea222"
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
