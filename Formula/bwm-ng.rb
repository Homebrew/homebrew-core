class BwmNg < Formula
  desc "Console-based live network and disk I/O bandwidth monitor"
  homepage "https://www.gropp.org/?id=projects&sub=bwm-ng"
  url "https://github.com/vgropp/bwm-ng/archive/v0.6.3.tar.gz"
  sha256 "c1a552b6ff48ea3e4e10110a7c188861abc4750befc67c6caaba8eb3ecf67f46"
  license "GPL-2.0-or-later"
  head "https://github.com/vgropp/bwm-ng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6813a187834a07be918ca68fd19356473c06507cc168aa6598c512f66fdf1a27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f572a2c3cba92b810273eec515a00b0dc406319efd33934a571e97a2f48fb9c"
    sha256 cellar: :any_skip_relocation, monterey:       "5c348d9959e22e50abd4182becbe38b683712988be164097e2ba2c685b49c506"
    sha256 cellar: :any_skip_relocation, big_sur:        "174c1fe863ea893c778909824972bebf6691c399076db4ca638dc2cee3b8c065"
    sha256 cellar: :any_skip_relocation, catalina:       "8ece99c9c9349e80ac741aa8beafc3ea77ae62035279ed5da0c79d201d762882"
    sha256 cellar: :any_skip_relocation, mojave:         "34ce809be16ab1eef9106643f22ff223a8da78a6c8336bd86e14dd41dccbec09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c116063a31ada221daff5f86798ab5cb90806e00e02f2b4ffda7092bd5caab"
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
