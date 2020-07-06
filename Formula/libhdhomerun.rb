class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20200521.tgz"
  sha256 "a61038f0a78c5dcab3508927ba47ac6ec47840f3d42a2df2b02034cfd7400668"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "f2ae936a544ec2f145195db79b83760aae0fd47045e7e255b17dc19acf4b0b98" => :catalina
    sha256 "32e8a587fe7df2e274d02261178bcdb4a1575bfd43bbb8f0f97cf9d11fb0d9d3" => :mojave
    sha256 "5532b7fbba3fb88fb3733b12cd2e173575c57bc9ca85e4a8db79639d4786d713" => :high_sierra
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
