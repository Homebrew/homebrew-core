class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.9.tar.gz"
  sha256 "b8efbcf3b04db809a28625603612924f8b587fce5993b85de0cc9d3cf8b68e40"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf63c85d3d1f00a6b9868069414cc5a0809e9ad01865033a361c6ab6fceb0b31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b425b8b3611b9cbf382f18756ab8fc4f7ee64b07150df7f9d0b5fe5d2c87771b"
    sha256 cellar: :any_skip_relocation, monterey:       "20cdaf7bf6295c9ed68b6f4d49350d666cc81a21e3e8090cb516c7dceea10d1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4523d6b80c7fd6b81f49e065312401877932b48d240c4d389b9a1f128b98388"
    sha256 cellar: :any_skip_relocation, catalina:       "f8f56eea9245a06868bbe5b2e868763913d66304daedacf2c8d36c41d5053a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4ff3f1a63038b392b18f55ea800aa25b1c04a8a582af38ba51af198bced20a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
