class Gifify < Formula
  desc "Turn movies into GIFs"
  homepage "https://github.com/jclem/gifify"
  url "https://github.com/jclem/gifify/archive/refs/tags/v4.0.tar.gz"
  sha256 "4cb967e8d0ba897bc91a60006e34299687f388dd47e05fd534f2eff8379fe479"
  license "MIT"
  head "https://github.com/jclem/gifify.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "112f3fcebc9d5ec54142bcb1c376f314a82a69212c9a58fc7a20e9c64526abcb"
  end

  depends_on "ffmpeg"
  depends_on "imagemagick"

  uses_from_macos "bc"

  def install
    bin.install "gifify.sh" => "gifify"
  end

  test do
    system "ffmpeg", "-f", "lavfi", "-i", "testsrc", "-t", "1", "-c:v", "libx264", "test.m4v"
    system bin/"gifify", "test.m4v"
  end
end
