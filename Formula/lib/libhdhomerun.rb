class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20231214.tgz"
  sha256 "552a102e8aa2abcc416090dec2f6f80da59f97f91f57968e9e9d7b3dc005dbaf"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf929657af2d6b7a51f5c59ebd1c97d52acf78d0e1ef1f9b4316d866bb7b154b"
    sha256 cellar: :any,                 arm64_ventura:  "2f892b62cb46c9fda84a9c376b2f71d76d28da931ddbfe97b70a95bb71fa1745"
    sha256 cellar: :any,                 arm64_monterey: "7df49e0500cfa2093abc6bba2ae5620b59932c3a3a6c9c371b29396ba87c91f0"
    sha256 cellar: :any,                 sonoma:         "d6d58fbfd63851b100df4e12d5ccfa76790e30447756cf3f8087eb5a0080052d"
    sha256 cellar: :any,                 ventura:        "0a3f2301921fee8192595b75f20e758b2dc3842552f1b85dbca92c6cc2210621"
    sha256 cellar: :any,                 monterey:       "0387bd044b115f24f875150a4b21861c4485fec79d01e87e97ebe683a8a87383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01610b0e16fa4b1796beb67c8278a72e9aed98666fd1d78590985616f9cd6a1f"
  end

  def install
    suffix = if OS.mac?
      Hardware::CPU.arm? ? "_arm64" : "_x64"
    else
      ""
    end

    targets = ["hdhomerun_config#{suffix}", shared_library("libhdhomerun#{suffix}")]

    system "make", *targets
    bin.install "hdhomerun_config#{suffix}" => "hdhomerun_config"
    lib.install shared_library("libhdhomerun#{suffix}") => shared_library("libhdhomerun")
    include.install Dir["hdhomerun*.h"]
  end

  test do
    # Devices may be found or not found, with differing return codes
    discover = pipe_output("#{bin}/hdhomerun_config discover")
    assert_match(/no devices found|hdhomerun device|found at/, discover)
  end
end
