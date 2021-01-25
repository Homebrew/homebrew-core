class BwmNg < Formula
  desc "Console-based live network and disk I/O bandwidth monitor"
  homepage "https://www.gropp.org/?id=projects&sub=bwm-ng"
  url "https://github.com/vgropp/bwm-ng/archive/v0.6.3.tar.gz"
  sha256 "c1a552b6ff48ea3e4e10110a7c188861abc4750befc67c6caaba8eb3ecf67f46"
  license "GPL-2.0-or-later"
  head "https://github.com/vgropp/bwm-ng.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "174c1fe863ea893c778909824972bebf6691c399076db4ca638dc2cee3b8c065" => :big_sur
    sha256 "5f572a2c3cba92b810273eec515a00b0dc406319efd33934a571e97a2f48fb9c" => :arm64_big_sur
    sha256 "8ece99c9c9349e80ac741aa8beafc3ea77ae62035279ed5da0c79d201d762882" => :catalina
    sha256 "34ce809be16ab1eef9106643f22ff223a8da78a6c8336bd86e14dd41dccbec09" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV.append "CFLAGS", "-std=gnu89"

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "<div class=\"bwm-ng-header\">", shell_output("#{bin}/bwm-ng -o html")
  end
end
