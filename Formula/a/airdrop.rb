class Airdrop < Formula
  desc "CLI Utility for Apple AirDrop"
  homepage "https://github.com/xvoland/airdrop"
  license "MIT"
  version "0.3.6"
  url "https://github.com/xvoland/airdrop/releases/download/v0.3.6/airdrop_darwin_arm64.tar.gz"
  sha256 "37420aed3a0a429086273e3480201a41cdb948ffd18e1484e50dc92b9f55e569"

  def install
    bin.install "airdrop"
  end

  test do
    system bin/"airdrop", "-version"
  end
end
