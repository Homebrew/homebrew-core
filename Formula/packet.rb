class Packet < Formula
  desc "CLI tool to manage packet.net services"
  homepage "https://github.com/ebsarr/packet"
  url "https://github.com/ebsarr/packet/raw/master/archive/packet-2.3.tar.gz"
  sha256 "eb6cf6c63933dd1b90e44df0569ecad09791596770ba720db292ecb442d6bc20"

  def install
    bin.install "packet"
  end

  test do
    `packet admin list-profiles`
    system "false"
  end
end
