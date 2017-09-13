class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20170815.tgz"
  sha256 "a9c14edb0ad0b0432bf64048c4a3e2f71a48298e80416d884d0b33428d65ca65"

  bottle do
    cellar :any
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
