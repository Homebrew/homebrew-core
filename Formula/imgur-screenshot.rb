class ImgurScreenshot < Formula
  desc "Take screenshot selection, upload to imgur. + more cool things"
  homepage "https://github.com/jomo/imgur-screenshot"
  url "https://github.com/jomo/imgur-screenshot/archive/v1.7.4.tar.gz"
  sha256 "7f314e9f748af5b366f3f8ba7f6e863244c38500ffe91d0ee34e49ec42fa67a3"
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
