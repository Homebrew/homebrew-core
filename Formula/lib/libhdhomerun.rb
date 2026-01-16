class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20250506.tgz"
  sha256 "879b1bc476c9b93e77ee280a84fc1157e7cc47d43ed9c8398d88a8ac5f35c034"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0863843dfe760dd0454dae929a74f5230819eb2261ca61604ba41ce4044a9a1d"
    sha256 cellar: :any,                 arm64_sequoia: "b5e3c2ecfd8f80433a08d6cb12b312cc7ba251a0ddf1ca97580a10f4c598e69c"
    sha256 cellar: :any,                 arm64_sonoma:  "d4e45edcb85bc4fd9a91e31ab8746fbd4b266c96dd20f93ace422219a1b2d397"
    sha256 cellar: :any,                 arm64_ventura: "328ec2c2954853416d1d40cdc8c809b3191f2098b73776d30dabe6875439d173"
    sha256 cellar: :any,                 sonoma:        "ad1590aa306190614b9ba2a331f40c24a9c502f2fdcf9c29534f545f98997033"
    sha256 cellar: :any,                 ventura:       "7e8887f15b1e3e8bb58d7b49ad4030cee33e816d355ce19a79141c0bed0835ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0308f092dc2348b44aa5c3e63afaf14f40e6c824f330ff9f1df3a5848b7f4a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "267e2668fdd5abf33dd50623014e4e4c5724204159a71a5f51a8fc38a9932390"
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
