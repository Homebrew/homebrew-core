class Amazechain < Formula
  desc "Ethereum-compatible blockchain(execution client), written in Go"
  homepage "https://github.com/WeAreAmaze/amc"
  url "https://github.com/WeAreAmaze/amc/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7c7974f116dffa7835ecbfa690694d918076f327408d03093b590cbed8c1209a"
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
