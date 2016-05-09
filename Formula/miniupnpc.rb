class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.tar.gz"
  sha256 "d434ceb8986efbe199c5ca53f90ed53eab290b1e6d0530b717eb6fa49d61f93b"

  bottle do
    cellar :any
    sha256 "a19062a31cca2b390b9c809274a36da71480593da190354d3e8c399c1fffd956" => :el_capitan
    sha256 "000120bb360335e89a47011d137dbfb1ed118a39514e03c42950bfc42d0433ad" => :yosemite
    sha256 "6cc37e4126cd71878f4e0270e2247fba5e3a7c4ec8bb5e21d37ecb660c0bba20" => :mavericks
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
