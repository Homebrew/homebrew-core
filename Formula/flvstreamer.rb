class Flvstreamer < Formula
  desc "Stream audio and video from flash & RTMP Servers"
  homepage "https://www.nongnu.org/flvstreamer/"
  url "https://download.savannah.gnu.org/releases/flvstreamer/source/flvstreamer-2.1c1.tar.gz"
  sha256 "e90e24e13a48c57b1be01e41c9a7ec41f59953cdb862b50cf3e667429394d1ee"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "207ffd2262cd3767e7443f9b389100eb8788ceeb48dbe06030452b4e30d132f3" => :mojave
    sha256 "52d09a95883b401b1d77d0e85354099cc351285a2243d00c257778033f36dbf6" => :high_sierra
    sha256 "e257779383d236611212078f2e6db28d457d51a282d6163806e0232134a046b0" => :sierra
    sha256 "5a4b649ce0f2c32bca4091f4867a37cca0e8ae2a292d4ef29aa2949530bdd651" => :el_capitan
    sha256 "243e6ce44b77212ff84e3a739bf2b203c687bdcdd36b17ba24daa5335bf0a151" => :yosemite
    sha256 "26ba92a604070dd27301456d120121618865108b33089191cd7ddcee78fbc465" => :mavericks
  end

  conflicts_with "rtmpdump", :because => "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  def install
    system "make", "posix"
    bin.install "flvstreamer", "rtmpsrv", "rtmpsuck", "streams"
  end

  test do
    system "#{bin}/flvstreamer", "-h"
  end
end
