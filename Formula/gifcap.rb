class Gifcap < Formula
  desc "Capture video from an Android device and make a gif"
  homepage "https://github.com/outlook/gifcap"
  url "https://github.com/outlook/gifcap/archive/1.0.3.tar.gz"
  sha256 "43b5f477b11f479ce2f4621e0e2c90ed5bc4563fc5f1dcbabfa6fe72e02454c9"
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
