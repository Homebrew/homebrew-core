class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.tar.gz"
  sha256 "d434ceb8986efbe199c5ca53f90ed53eab290b1e6d0530b717eb6fa49d61f93b"

  bottle do
    cellar :any
    sha256 "8434730606542a3b9c2a4e79d3fbcaf9bdf311aca79875a18d4274c79090056a" => :sierra
    sha256 "15e81b0d06dc52291dd1146701bc0fed14ed9423fd182782f7538326fccc52cc" => :el_capitan
    sha256 "40c1d6a4be66b1c5d69aa420ea33864f3330c68ff098571f6483e67c463fab42" => :yosemite
    sha256 "f92562f92f51ab605904f4a540b107a526d16ddd1a4d9567f9c40ec4843ed125" => :mavericks
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
