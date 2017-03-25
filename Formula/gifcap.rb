class Gifcap < Formula
  desc "Capture video from an Android device and make a gif"
  homepage "https://github.com/outlook/gifcap"
  url "https://github.com/outlook/gifcap/archive/1.0.4.tar.gz"
  sha256 "32747a6cf77f7ea99380752ba35ecd929bb185167e5908cf910d2a92f05029ad"
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
