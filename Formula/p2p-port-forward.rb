class P2pPortForward < Formula
  desc "Command-line utility to forward ports using zerotier-sdk"
  homepage "https://github.com/selvakn/p2p-port-forward"

  url "https://github.com/selvakn/p2p-port-forward/releases/download/v1.0.1/p2p-port-forward-darwin-10.11-amd64"
  version "1.0.1"
  sha256 "2a52ca89edf34a95ecc64b9f0425f61d92d71e0d9678a54e2fa3d874e677239a"

  bottle :unneeded

  def install
    mv "p2p-port-forward-darwin-10.11-amd64", "p2p-port-forward"
    bin.install "p2p-port-forward"
  end

  test do
    system "#{bin}/delta", "--version"
  end
end
