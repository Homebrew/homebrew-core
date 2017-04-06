class ColorCode < Formula
  desc "Free advanced MasterMind clone"
  homepage "http://colorcode.laebisch.com/"
  url "http://colorcode.laebisch.com/download/ColorCode-0.8.5.tar.gz"
  sha256 "7c128db12af6ab11439eb710091b4a448100553a4d11d3a7c8dafdfbc57c1a85"
  revision 1

  bottle do
    cellar :any
    sha256 "97f97f9cf8117d1acf3159c675c86daeaca8cfdf16033f9b56490fd1b39f8ea2" => :sierra
    sha256 "97f97f9cf8117d1acf3159c675c86daeaca8cfdf16033f9b56490fd1b39f8ea2" => :el_capitan
    sha256 "ca1ad797d0438d8c9d0aea74b3cb70dfb48963b2309e04b69849694957dacdda" => :yosemite
  end

  depends_on "qt"

  def install
    system "qmake"
    system "make"
    prefix.install "ColorCode.app"
    bin.write_exec_script "#{prefix}/ColorCode.app/Contents/MacOS/colorcode"
  end

  test do
    system "#{bin}/colorcode", "-h"
  end
end
