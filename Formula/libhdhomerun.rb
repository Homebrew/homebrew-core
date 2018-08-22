class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20180817.tgz"
  sha256 "437888b27206f526827ee7a4c57c1c167a36483b0445232e07fb7bb7ee854b42"

  bottle do
    cellar :any
    sha256 "075154089fdd7f720badda9269c652048ec0db52ddafd9d281a20ee3776bdf33" => :mojave
    sha256 "05449be9e4782745ca9853e24ee07614a74eaf8fa62b0eb8d1540af4f1cafa98" => :high_sierra
    sha256 "75ef974d3f15f7c48019536c2f7b13959c6b133b52196d6d54afa00665495380" => :sierra
    sha256 "0e6a5b4eadff2d39e56fc84d9c105eebb262396acdf1f1452206e7ca64a94589" => :el_capitan
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
