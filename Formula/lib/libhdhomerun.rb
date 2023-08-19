class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20230719.tgz"
  sha256 "aa8f1c23e6d38f0d684426cdc1cbfced953a2a9dec3fbe645ab11c15a8c0b4d6"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e2bc19a2d1a355af23bc868fba14f4cc449d6ad6cc37cbcdf26682c57e313faf"
    sha256 cellar: :any,                 arm64_monterey: "05349118038344aa09623f0b63070e7e78f7668651c28f198c97a72eb8420360"
    sha256 cellar: :any,                 arm64_big_sur:  "39f229f4a27ff97b69786eb2b1193dc067b8751aa6bb663eb37759d364bf1329"
    sha256 cellar: :any,                 ventura:        "fae16dfcd7a2d13eed9292e50cee14abd0863c821418f7c63241b4231ede1c47"
    sha256 cellar: :any,                 monterey:       "6f58450b1f3f0a00bbc8cb054989b895d58f807628adfe3f869af7c28f3395b2"
    sha256 cellar: :any,                 big_sur:        "c902fa5a109d13be0f85a191a70df94f2a988e79ce340970b0d015bc3fffbd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e84c63fa35aca15b6d409261d68fc0beb660d5a964f0145e3dc8cc63bc01b043"
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
