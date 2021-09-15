class Ipcalc < Formula
  desc "Calculate various network masks, etc. from a given IP address"
  homepage "http://jodies.de/ipcalc"
  url "http://jodies.de/ipcalc-archive/ipcalc-0.41.tar.gz"
  sha256 "dda9c571ce3369e5b6b06e92790434b54bec1f2b03f1c9df054c0988aa4e2e8a"

  livecheck do
    url "http://jodies.de/ipcalc-archive/"
    regex(/href=.*?ipcalc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fdb1f6c264ecbd824e0a514704000f46825e6c092487cdd467c964f12d3bf960"
  end

  def install
    bin.install "ipcalc"
  end

  test do
    system "#{bin}/ipcalc", "--nobinary", "192.168.0.1/24"
  end
end
