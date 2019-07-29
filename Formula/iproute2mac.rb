class Iproute2mac < Formula
  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.2.2/iproute2mac-1.2.2.tar.gz"
  sha256 "37ea67da5bbcac5977877c4a3a1ea8c6149785d44c65ffdaf60f9e2ba689def3"

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
