class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20170930.tgz"
  sha256 "0cb392231961fab6c226c69012503e2ebe46ac0f13512689bd37d6cf9ee838a1"

  bottle do
    cellar :any
    sha256 "32c26189630211d5f12d7d7ed27a7f55091fb5431abbccf9157f0338a36bdf40" => :high_sierra
    sha256 "a9b1b6733c0afaea2500f83425caa3c395535c5bea699e3e7bc968a402d813db" => :sierra
    sha256 "2fcf5b4264ee6604f5ebbc97d52de2d2558a5793887540e2e9748b424a33e8e5" => :el_capitan
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
