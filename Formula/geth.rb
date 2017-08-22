class Geth < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.6.7.tar.gz"
  sha256 "3e2a75b55ee8f04f238682164a7a255cae7a1f939893c5c97c2adcf48d7d4d49"
  head "https://github.com/ethereum/go-ethereum.git"

  depends_on "go" => :build

  def install
    system "make", "geth"
    bin.install "build/bin/geth"
  end

  test do
    system "#{bin}/geth", "-h"
    system "#{bin}/geth", "version"
  end
end
