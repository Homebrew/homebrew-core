class ImgurScreenshot < Formula
  desc "Take screenshot selection, upload to imgur. + more cool things"
  homepage "https://github.com/jomo/imgur-screenshot"
  url "https://github.com/jomo/imgur-screenshot/archive/v1.7.4.tar.gz"
  sha256 "1f0f2d5e201f1fdc1472f201f04430d809bf442ad034c194e70d8921823e990e"
  head "https://github.com/jomo/imgur-screenshot.git"

  bottle :unneeded

  def install
    bin.install "imgur-screenshot.sh"
  end

  test do
    system "#{bin}/imgur-screenshot.sh", "--check" # checks deps
  end
end
