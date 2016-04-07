class ImgurScreenshot < Formula
  desc "Take screenshot selection, upload to imgur. + more cool things"
  homepage "https://github.com/jomo/imgur-screenshot"
  url "https://github.com/jomo/imgur-screenshot/archive/v1.7.1.tar.gz"
  sha256 "2a9ac0f59b3b6819fec5dfc4bd50d1c28adefbdaf31f0bf93a52fa40b283cf44"
  head "https://github.com/jomo/imgur-screenshot.git"

  bottle :unneeded

  option "with-terminal-notifier", "Needed for Mac OS X Notifications"

  depends_on "terminal-notifier" => :optional

  def install
    bin.install "imgur-screenshot.sh"
  end

  test do
    system "#{bin}/imgur-screenshot.sh", "--check" # checks deps
  end
end
