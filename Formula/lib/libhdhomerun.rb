class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://github.com/Silicondust/libhdhomerun"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20261107.tgz"
  sha256 "a273f2267b32e8931a7b733d37a28367fa65ee5ce875036d0acd5b2948edc07d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f578fe3c5036b4afa472e9a6e3403ac064a0fbda8e533ec898847da98fbf9549"
    sha256 cellar: :any, arm64_tahoe:       "6368ef60b78c03f73c9f998df14d9edc9ded8d77f396de82a1f517766653f528"
    sha256 cellar: :any, arm64_sequoia:     "ecaed292b6d261923c5b13747aee5e628825c01116d320be48d7624556eab8f3"
    sha256 cellar: :any, arm64_linux:       "3eb87ade6db53ed7030f3e9136200b98578464191c6d0b29e5960a1baf6f5585"
    sha256 cellar: :any, x86_64_linux:      "788bee8384b8ccdb7b07fde67998671b76efe09b46b9919d996e4935b33269e3"
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
