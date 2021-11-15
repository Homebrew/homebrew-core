class Gifify < Formula
  desc "Turn movies into GIFs"
  homepage "https://github.com/jclem/gifify"
  url "https://github.com/jclem/gifify/archive/v4.0.tar.gz"
  sha256 "4cb967e8d0ba897bc91a60006e34299687f388dd47e05fd534f2eff8379fe479"
  license "MIT"
  head "https://github.com/jclem/gifify.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c2721950d78064f75c5f4dbe1c8dc72bfbe3ddb34c5a8d94a3198551bf12aacf"
  end

  depends_on "ffmpeg"
  depends_on "imagemagick"

  uses_from_macos "bc"

  def install
    bin.install "gifify.sh" => "gifify"
  end

  test do
    system "ffmpeg", "-f", "lavfi", "-i", "testsrc", "-t", "1", "-c:v", "libx264", "test.m4v"
    system "#{bin}/gifify", "test.m4v"
  end
end
