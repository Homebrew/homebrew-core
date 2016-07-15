class Nethogs < Formula
  desc "Net top tool grouping bandwidth per process"
  homepage "https://raboof.github.io/nethogs/"
  url "https://github.com/raboof/nethogs/archive/v0.8.5.tar.gz"
  sha256 "6a9392726feca43228b3f0265379154946ef0544c2ca2cac59ec35a24f469dcc"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a4a5fbe64015f701ebb4dde35905f333c66ed2365b5880d54f1ffccd1261616" => :el_capitan
    sha256 "95ed6efb5d64d447d4c5b86e65746282b4e146610ce008e37a73c75ffcfd2db5" => :yosemite
    sha256 "8b885955dcf5abcc9bdf424a1db9f03f94e287ffddaef9fd281d55c4ed8928fd" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Using -V because other nethogs commands need to be run as root
    system sbin/"nethogs", "-V"
  end
end
