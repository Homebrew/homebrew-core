class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20210210.tgz"
  sha256 "b996389aa6f124a6d9dc1e75ec749e86d06102e2b3e7359d57163d4cc6e633f8"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libhdhomerun[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "448fc727d716aac2001deb79ac3a0a224b35f87f9dbd1f405b5b0f01be5dea35"
    sha256 cellar: :any, big_sur:       "51bdad683da9c0ad2bb62861fe17558e76fdf811587bec2202c4b3bb25d5b125"
    sha256 cellar: :any, catalina:      "de8bf4fd6b240720fcb4b659dc204125d7fd6269843ab7e42583fb7e4a2910ef"
    sha256 cellar: :any, mojave:        "ebe04832479909f66e0f61f5dbc191593936d3362aace2978427366b46b28db9"
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
