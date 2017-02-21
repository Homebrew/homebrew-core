class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20161117.tgz"
  sha256 "23a3484723f3744eb38349d19cbe7d25b5bed27adf64929bd174c1669b194a8a"

  bottle do
    cellar :any
    sha256 "92d67b2eacd51cac3123b6fbfa9f9a17f3010595c941952935ad824bf84160d6" => :sierra
    sha256 "5ee8e88dab6dcd855f05d7221093eaab214a3dc41d1a5fc6c0aafcfabb5af9c0" => :el_capitan
    sha256 "1188045a7ca69b22a999051618fff9648baf0d7977612844d6997cdc58914b6b" => :yosemite
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
