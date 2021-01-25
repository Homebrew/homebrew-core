class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20200907.tgz"
  sha256 "cbaeb779c5a4e07db45310ef4271872bcb7c472402ebc3c58e224653c09400ed"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libhdhomerun[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    cellar :any
    sha256 "71659dd19092a36e4273376c2089beb1dc6624d1110570d92ce77c937e91f114" => :big_sur
    sha256 "42dd7b1352a31dcd5e68a88a8e84fb574ae7f05964648a7a348dbefc228a1c32" => :arm64_big_sur
    sha256 "85109e085bf10c74f5f30e9f472773994bed3ccbdc14b1981a057d857ec71680" => :catalina
    sha256 "f4a3852863bbfd997c924752b1fbdfa55522e899cde1a2defc2306c29b763e28" => :mojave
    sha256 "a79cb2c05ae52f5a39ca069f0c4d2c1a9dac57f3f7d3f608fb8b2bf4eb8511e9" => :high_sierra
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
