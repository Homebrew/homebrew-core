class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20180327.tgz"
  sha256 "d91fd3782f9a0834242f7110c44067647843602f8e95052045250b7c229ccbd5"

  bottle do
    cellar :any
    sha256 "640fbf92c8aa19583b4af8a003ad2e02458661986eb9a37e74b1e7084e8d99b3" => :mojave
    sha256 "207b5043bf3ab3fe71f16fc2593f5ba2107c65c88bf4af1820d8f014ea7fcaf1" => :high_sierra
    sha256 "09735702da881d2cc637b26c6696cdb0e884c3bafd573a62138643343dd5cdcf" => :sierra
    sha256 "a778d0a53f7452e941fb3065a45b5b152a916ec8c521fdbb7cffec7f4c208a47" => :el_capitan
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
