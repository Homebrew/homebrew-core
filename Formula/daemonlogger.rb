class Daemonlogger < Formula
  desc "Network packet logger and soft tap daemon"
  homepage "https://sourceforge.net/projects/daemonlogger/"
  url "https://downloads.sourceforge.net/project/daemonlogger/daemonlogger-1.2.1.tar.gz"
  sha256 "79fcd34d815e9c671ffa1ea3c7d7d50f895bb7a79b4448c4fd1c37857cf44a0b"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "beee453bd9b0404bd4a145fb466eaf3ed8212d24570bc4eb0fa5480cda06c4c9"
    sha256 cellar: :any,                 arm64_monterey: "5df034d135e6be79eee9c27f0b53cc1b9531b8d027c40f6e7c9b76561a0476d6"
    sha256 cellar: :any,                 arm64_big_sur:  "cebaf67384c1d536a827bd4da514b70f2342315cfc013fa3e0e9fd0c658c22a4"
    sha256 cellar: :any,                 ventura:        "f85bf445ce68b5ab5914671739bebfe81ed91f7ee0bed9d4e92667e42edf6c5e"
    sha256 cellar: :any,                 monterey:       "1c2f08e5d06fd71339d5f2c3f730b2e15ef60ceee56c23efa98026f65ec94954"
    sha256 cellar: :any,                 big_sur:        "37a025cbb7898243913ad07bb094b2195e27587b5458d465fea790d30f13af67"
    sha256 cellar: :any,                 catalina:       "8f2af84c9d476a7bd11e30185794bf107a92ae32f92b84f38f5a629f368ad6c2"
    sha256 cellar: :any,                 mojave:         "1cac9c8c17cd804206440d35ec88f49e8162ec102a4e561aa103f528b6d49382"
    sha256 cellar: :any,                 high_sierra:    "04242956845e71d839b050dd765829a217268486eb625a481a3fae85bd577f0d"
    sha256 cellar: :any,                 sierra:         "c3ac14ab04174e06129fc0a51d31ad992f3d11f362ecb1cf3803092b6c68b146"
    sha256 cellar: :any,                 el_capitan:     "582aa8e07f269bdfa00b1f66157c06339b62285d94f6b8ffa6a472eac063e5e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "462b6ecbf94169210be2591de29de97b69a701cc810485fb956bf7892e1b57fa"
  end

  depends_on "libdnet"

  uses_from_macos "libpcap"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/daemonlogger", "-h"
  end
end
