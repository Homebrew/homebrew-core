class Timer < Formula
  desc "Command-line tool to set a timer"
  homepage "https://github.com/annpocoyo/timer"
  url "https://github.com/annpocoyo/timer/raw/master/archive/Timer-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "f81266d409a6429be6a6d2cf21bb9caad1714c908484013a1049e3407c67a928"

  bottle :unneeded

  def install
    bin.install "Timer"
  end
end
