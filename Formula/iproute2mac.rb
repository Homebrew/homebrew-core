class Iproute2mac < Formula
  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.2.1/iproute2mac-1.2.1.tar.gz"
  sha256 "26dabecd2cf065c8354984a327784aad730fb019d67561bc2d00b415684ff39f"

  bottle :unneeded

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    bin.install "src/ip.py" => "ip"
  end

  test do
    system "#{bin}/ip", "route"
    system "#{bin}/ip", "address"
    system "#{bin}/ip", "neigh"
  end
end
