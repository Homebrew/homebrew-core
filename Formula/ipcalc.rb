class Ipcalc < Formula
  desc "Calculate various network masks, etc. from a given IP address"
  homepage "http://jodies.de/ipcalc"
  url "https://github.com/kjokjo/ipcalc/archive/refs/tags/0.51.tar.gz"
  sha256 "a4dbfaeb7511b81830793ab9936bae9d7b1b561ad33e29106faaaf97ba1c117e"

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
