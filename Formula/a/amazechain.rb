class Amazechain < Formula
  desc "Ethereum-compatible blockchain(execution client), written in Go"
  homepage "https://github.com/WeAreAmaze/amc"
  url "https://github.com/WeAreAmaze/amc/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2400f2ed9747a065f8ada4d6b9eb5f53b28cf0b61df8bf9cadefd1a3dbd21efd"
  license all_of: ["GPL-3.0-or-later"]
  head "git@github.com:WeAreAmaze/amc.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "gcc" => :build
  depends_on "go@1.20" => :build

  def install
    system "make", "amc"
    bin.install Dir["build/bin/*"]
  end

  test do
    system "#{bin}/amazechain", "-v"
  end
end
