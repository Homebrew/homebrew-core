class Flvstreamer < Formula
  desc "Stream audio and video from flash & RTMP Servers"
  homepage "https://www.nongnu.org/flvstreamer/"
  url "https://download.savannah.gnu.org/releases/flvstreamer/source/flvstreamer-2.1c1.tar.gz"
  sha256 "e90e24e13a48c57b1be01e41c9a7ec41f59953cdb862b50cf3e667429394d1ee"
  license "GPL-2.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/flvstreamer/source/"
    regex(/href=.*?flvstreamer[._-]v?(\d+(?:\.\d+)+(?:[a-z]\d*)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de5f4ef4be5bd145b783b309b8be860215f308abbd3134d6def0734861ae63d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c96f83be0a0a72e6172cd9d1459d268cd58c16c930bf2a5c5e60de50654faef3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12ad45a6edb6af98a60963e3a5f302ca40055290233228adf54ae4cd9e491094"
    sha256 cellar: :any_skip_relocation, ventura:        "b80c82043109dae0ab1868a5f3fadd6897663f55cea6321b6a76364bd91ea5bb"
    sha256 cellar: :any_skip_relocation, monterey:       "ce990e2bc2f6fe933e3203b6a62e0a7f42c899a29a4b77f453ba9ee93b82f8b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b148a052d107098db010c7f1884784dacba4f2f27e7ca9d50c9e3347096a4aa3"
    sha256 cellar: :any_skip_relocation, catalina:       "cfc6a5308ead52bccf753068f8de3a57abd47cf4bdf12d046ca540f3b38ebf8d"
    sha256 cellar: :any_skip_relocation, mojave:         "207ffd2262cd3767e7443f9b389100eb8788ceeb48dbe06030452b4e30d132f3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "52d09a95883b401b1d77d0e85354099cc351285a2243d00c257778033f36dbf6"
    sha256 cellar: :any_skip_relocation, sierra:         "e257779383d236611212078f2e6db28d457d51a282d6163806e0232134a046b0"
    sha256 cellar: :any_skip_relocation, el_capitan:     "5a4b649ce0f2c32bca4091f4867a37cca0e8ae2a292d4ef29aa2949530bdd651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99df5a533003260eea6277d1fa2bb80d0354b666a6a99195c46813e3313c701f"
  end

  conflicts_with "rtmpdump", because: "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  def install
    system "make", "posix"
    bin.install "flvstreamer", "rtmpsrv", "rtmpsuck", "streams"
  end

  test do
    system "#{bin}/flvstreamer", "-h"
  end
end
