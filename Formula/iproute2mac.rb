class Iproute2mac < Formula
  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/archive/v1.2.0.tar.gz"
  sha256 "d04f08ee2070ed92c3b1416f0bf02b0bd65ea16f7c380113a0ad7769882e0ef4"

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
