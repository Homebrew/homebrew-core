class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20210624.tgz"
  sha256 "deaf463bbcc3eefa72f97199efb6213f7b0e2c8e91f1b3d2cbf52056a8715d15"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libhdhomerun[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "336e6041951a08ba420b8ef850a7e33d50234ed40a2296f91d9182585caa2b96"
    sha256 cellar: :any, arm64_big_sur:  "bc14665c9ca08d825b980954f49820d880891b71b253720c36fe1533aa1c6558"
    sha256 cellar: :any, monterey:       "95875b8d94b9cdeb9bd83df420f7ab7631f315f14a6498b19f0c48856e64c789"
    sha256 cellar: :any, big_sur:        "dd3696fe6fcd4f64aeaef700271fc13a833bf82d7d49be6043428bbe9ae51ac4"
    sha256 cellar: :any, catalina:       "913fe2b4e1e64dfe288715e6ec64c061fb580df6d2fcb57cd6ae113b00b7d0cf"
    sha256 cellar: :any, mojave:         "a8ad1023d5b5239db535f3757bda0241165c5fc7d13e9b4bdc9fb35c76b7db5d"
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
    assert_match(/no devices found|hdhomerun device|found at/, discover)
  end
end
