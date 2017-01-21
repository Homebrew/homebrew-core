class Gifcap < Formula
  desc "Capture video from an Android device and make a gif"
  homepage "https://github.com/outlook/gifcap"
  url "https://github.com/outlook/gifcap/archive/1.0.1.tar.gz"
  sha256 "60a0066e57cf05c3ecceb582200594457f9295628ccc79b215e363386b0ae604"
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
