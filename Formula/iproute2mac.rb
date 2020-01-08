class Iproute2mac < Formula
  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.2.3/iproute2mac-1.2.3.tar.gz"
  sha256 "95ef8d4b0e32e4d3e3d975afa11d7aa0797d59b0f2c21b73a4e26d357bd6f93f"

  bottle :unneeded

  def install
    bin.install "src/ip.py" => "ip"
  end

  test do
    system "#{bin}/ip", "route"
    system "#{bin}/ip", "address"
    system "#{bin}/ip", "neigh"
  end
end
