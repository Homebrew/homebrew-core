class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20230303.tgz"
  sha256 "7e872558f42818b1cd2f0ba0a0c6613315c4656b484fd2906d0b8f3ce7e0711a"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08a44f2faa458f8f5daccdd8f4e0260cdd9d90ffe04ecf654003fa793ab38a53"
    sha256 cellar: :any,                 arm64_monterey: "cec98272f219666bb9391102d7b6e1df239595c3deca28af55155df0e3efdbcc"
    sha256 cellar: :any,                 arm64_big_sur:  "1e2d97dd3e27ae330580fd7acac29a63f93701a34bf33b65852b15120cbef0bf"
    sha256 cellar: :any,                 ventura:        "3abe7e5c9bec9ddab9ed985ce05ecd0bc7f380f5ae9292e113bb9af733a330ef"
    sha256 cellar: :any,                 monterey:       "3e8684bb205562366851983e2718d4ce6c4572ab5bd11b259555a8f4e17af4e4"
    sha256 cellar: :any,                 big_sur:        "348e7a18e38b9ed4241732ae96a9cfa7e4a6fa9b1a8a255feae0e21001786ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b83da019f1a056f2fe9f939c58ce526aa77eb7098159c872c48f4ff9c859ed5"
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
