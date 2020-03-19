class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20200225.tgz"
  sha256 "f6493e4a643a4ba9c3b2424b7f491186efc2ba5fd93d2285d65b7c5aca676cf9"

  bottle do
    cellar :any
    sha256 "022b83d3c1cf86313b2b782034d21dca95321df3b0ffb1f36806650159963183" => :catalina
    sha256 "d8cb4211790fe521593e4832ec4512f43457cdae21437df08f83a948b0adeb30" => :mojave
    sha256 "8f73bd04733497f8d261da3487197a409d11765341eb030282017f3d6945e820" => :high_sierra
  end

  def install
    system "make"
    bin.install "hdhomerun_config"
    lib.install "libhdhomerun.dylib"
    include.install Dir["hdhomerun*.h"]
  end

  test do
    # Devices may be found or not found, with differing return codes
    discover = pipe_output("#{bin}/hdhomerun_config discover")
    assert_match /no devices found|hdhomerun device|found at/, discover
  end
end
