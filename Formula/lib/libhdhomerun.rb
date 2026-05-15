class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20260313.tgz"
  sha256 "792d43b98bdc146fa8872f8205f4f8feb1c1d5557e3c77edda6b6b1ede9b9db0"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c40ac7a094030a4f15e9edfac94ce0bf0d47742edaf0c035d021222527f6c174"
    sha256 cellar: :any,                 arm64_sequoia: "a3340353584c80d273aff9acee853ae3320c54c3f897daf1d4208f8c9aa9cbcd"
    sha256 cellar: :any,                 arm64_sonoma:  "adf8fe192ddd194186516644c31ac80031062e009ddb03dd653834e1b09f1be1"
    sha256 cellar: :any,                 sonoma:        "17c9afa4faba64af7726035a5b87fd326661c1f11fafcb5d935e53268a84f3af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f742f0f12a70fc98c70ce3ee227295f3bd83f5211004cf3e2f3f1a6d37bb435b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "573a0aed2cc1bed2f790a9e4bf13bc50f5860b9e10c9b241edcdae9510ceac86"
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
