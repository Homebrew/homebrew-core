class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20230505.tgz"
  sha256 "aa8f1c23e6d38f0d684426cdc1cbfced953a2a9dec3fbe645ab11c15a8c0b4d6"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d689d92bc54327a823aa282602c89480941e26d1316b123a16491d4d8bddbfee"
    sha256 cellar: :any,                 arm64_monterey: "aafd9311022302cfc15fbc3607a573215b7d5d367d7437555e6bb8a5658f4b5b"
    sha256 cellar: :any,                 arm64_big_sur:  "349db90961c509f61a4314fcb6a72151c88e71771342f40a25d1eae1bb716ea1"
    sha256 cellar: :any,                 ventura:        "a88197af57f160b3dbdf05497ca18931d5141c40807fc4c632828554a42cb710"
    sha256 cellar: :any,                 monterey:       "e7a9e400a7d3d602520586157397b5c8dcc17bcc2cf94c8228381c5b88116e97"
    sha256 cellar: :any,                 big_sur:        "ade0887894eeb4b32f5b2fd0a293277c36eb500df9fac60883816c011f5b3a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da26129c26072098fd07015edd7a37ba54bbddc9cb2c3e708c9ac750fd265b5"
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
