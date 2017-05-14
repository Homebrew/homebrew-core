class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.tar.gz"
  sha256 "d434ceb8986efbe199c5ca53f90ed53eab290b1e6d0530b717eb6fa49d61f93b"
  revision 1

  bottle do
    cellar :any
    sha256 "8434730606542a3b9c2a4e79d3fbcaf9bdf311aca79875a18d4274c79090056a" => :sierra
    sha256 "15e81b0d06dc52291dd1146701bc0fed14ed9423fd182782f7538326fccc52cc" => :el_capitan
    sha256 "40c1d6a4be66b1c5d69aa420ea33864f3330c68ff098571f6483e67c463fab42" => :yosemite
    sha256 "f92562f92f51ab605904f4a540b107a526d16ddd1a4d9567f9c40ec4843ed125" => :mavericks
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
