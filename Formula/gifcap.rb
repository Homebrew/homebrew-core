class Gifcap < Formula
  desc "Capture video from an Android device and make a gif"
  homepage "https://github.com/outlook/gifcap"
  url "https://github.com/outlook/gifcap/archive/1.0.2.tar.gz"
  sha256 "22b9668f08265e7c381881e3da95ae9aabb3fc897b7b3ab0fe08f437c98fb2c1"
  head "https://github.com/outlook/gifcap.git"

  bottle :unneeded

  depends_on "ffmpeg"
  depends_on "android-sdk" => :optional

  def install
    bin.install "gifcap"
  end

  test do
    assert_match /^usage: gifcap/, shell_output("#{bin}/gifcap --help").strip
  end
end
