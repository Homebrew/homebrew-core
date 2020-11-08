class Overdrive < Formula
  desc "Bash script to download mp3s from the OverDrive audiobook service"
  homepage "https://github.com/chbrown/overdrive"
  url "https://github.com/chbrown/overdrive/archive/2.1.1.tar.gz"
  sha256 "74ec42df2c5dda56bfe04c0f8b831d21fd1511c0ef2839dd2bd84d1fda2b8b6b"
  license "MIT"
  head "https://github.com/chbrown/overdrive.git"

  bottle :unneeded

  def install
    bin.install "overdrive.sh"
  end

  test do
    system "#{bin}/overdrive.sh", "-h"
  end
end
