class Minipro < Formula
  desc "Free and open TL866XX programmer"
  homepage "https://gitlab.com/DavidGriffith/minipro"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.3/minipro-0.3.tar.gz"
  sha256 "6096ebd683028da5787ecaf4c2c39a52a285371e7384c34c2f10b3583756b48d"

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/minipro", "-h"
  end
end
