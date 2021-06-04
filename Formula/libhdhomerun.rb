class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20210224.tgz"
  sha256 "b996389aa6f124a6d9dc1e75ec749e86d06102e2b3e7359d57163d4cc6e633f8"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libhdhomerun[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1bf15741fcc4269cdb2104b1fcf21647b7de206a88d688480ae259b37bfda732"
    sha256 cellar: :any, big_sur:       "fa8518d57964312f1189fac633ea7375d95dc6956b5dbd0ae771ca5d3669cd47"
    sha256 cellar: :any, catalina:      "9d4f46b6cfb2b04256d8141fb91a45145cbcdcbf20db8bac28197141bef40dd3"
    sha256 cellar: :any, mojave:        "25bab624ff734b8bd9ab2aad27a38b1b9dddfd38bfc8652c82961ac26d8c5eaa"
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
    assert_match(/no devices found|hdhomerun device|found at/, discover)
  end
end
