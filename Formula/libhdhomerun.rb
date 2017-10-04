class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20170930.tgz"
  sha256 "0cb392231961fab6c226c69012503e2ebe46ac0f13512689bd37d6cf9ee838a1"

  bottle do
    cellar :any
    sha256 "50f0abd3e95df7b7fee6672b9b536af4eb65239296b5db70fedd57323f9b0ecb" => :high_sierra
    sha256 "d80d2f22ee2960c8a085de0aaf44d0b7f96d743f838e6043901a3847f92ff333" => :sierra
    sha256 "dcb9d068072bedd4330a41970e8d991ed3204830effe9c924cb53f7b54ee9e0c" => :el_capitan
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
