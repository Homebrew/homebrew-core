class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20220303.tgz"
  sha256 "1e54ffefc2d4893911501da31e662b9d063e6c18afe2cb5c6653325277a54a97"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3fde9f90d28b9e63e96373c6cde0577e4d6b05abac924c6101b4ad495181a58e"
    sha256 cellar: :any,                 arm64_big_sur:  "44edebcb2619831a0cd87cfb9738ca8c115491d06a40ba83827973726c6da294"
    sha256 cellar: :any,                 monterey:       "c354a9ed82da03b4b224f94e6e7660d241797de40ac19dde30d3bb323bbd310b"
    sha256 cellar: :any,                 big_sur:        "767b1d44bbaa11c6f391a57d739b9eaa46d9eb36e5511ba5f2bfc1147437abb8"
    sha256 cellar: :any,                 catalina:       "5258e4ece26fb16ecfff072d444ff22203e7a0acd162a0ce5a20074ffe69d02a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9be792de3e833a8372f0b17cccb6a70787d973fbd6c3b2382daa6b52415fc6a"
  end

  def install
    system "make"
    bin.install "hdhomerun_config"
    lib.install shared_library("libhdhomerun")
    include.install Dir["hdhomerun*.h"]
  end

  test do
    # Devices may be found or not found, with differing return codes
    discover = pipe_output("#{bin}/hdhomerun_config discover")
    assert_match(/no devices found|hdhomerun device|found at/, discover)
  end
end
