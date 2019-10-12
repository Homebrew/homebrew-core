class Daemonlogger < Formula
  desc "Network packet logger and soft tap daemon"
  homepage "https://sourceforge.net/projects/daemonlogger/"
  url "https://downloads.sourceforge.net/project/daemonlogger/daemonlogger-1.2.1.tar.gz"
  sha256 "79fcd34d815e9c671ffa1ea3c7d7d50f895bb7a79b4448c4fd1c37857cf44a0b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8f2af84c9d476a7bd11e30185794bf107a92ae32f92b84f38f5a629f368ad6c2" => :catalina
    sha256 "1cac9c8c17cd804206440d35ec88f49e8162ec102a4e561aa103f528b6d49382" => :mojave
    sha256 "04242956845e71d839b050dd765829a217268486eb625a481a3fae85bd577f0d" => :high_sierra
    sha256 "c3ac14ab04174e06129fc0a51d31ad992f3d11f362ecb1cf3803092b6c68b146" => :sierra
    sha256 "582aa8e07f269bdfa00b1f66157c06339b62285d94f6b8ffa6a472eac063e5e5" => :el_capitan
    sha256 "3497b590f03a70d322452abd71a1121d9a952d05a82af875c1dc11e5ae0324d6" => :yosemite
    sha256 "c178b1f5f29b361308cc64944472604067282c56eeb29131674e89be30dacc78" => :mavericks
  end

  depends_on "libdnet"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/daemonlogger", "-h"
  end
end
