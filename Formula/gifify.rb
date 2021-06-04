class Gifify < Formula
  desc "Turn movies into GIFs"
  homepage "https://github.com/jclem/gifify"
  url "https://github.com/jclem/gifify/archive/v4.0.tar.gz"
  sha256 "4cb967e8d0ba897bc91a60006e34299687f388dd47e05fd534f2eff8379fe479"
  license "MIT"
  head "https://github.com/jclem/gifify.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "617b00e6f12cccfc26254ae3f29146e6bcdca8224b3307c405ae105e9ab9c48a"
  end

  depends_on "ffmpeg"
  depends_on "imagemagick"

  def install
    bin.install "gifify.sh" => "gifify"
  end

  test do
    system "ffmpeg", "-f", "lavfi", "-i", "testsrc", "-t", "1", "-c:v", "libx264", "test.m4v"
    system "#{bin}/gifify", "test.m4v"
  end
end
