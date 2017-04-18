class Iproute2mac < Formula
  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/archive/v1.1.2.tar.gz"
  sha256 "e228484bc54e56fc5932016f3e77751a1db155d01132553d1dad27b0fcc00b18"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "src/ip.py" => "ip"
  end

  test do
    system "#{bin}/ip", "route"
    system "#{bin}/ip", "address"
    system "#{bin}/ip", "neigh"
  end
end
