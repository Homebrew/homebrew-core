class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "ac68158751ae27a6fd58aa4acaa832a7cddabdce556a7889c7465df627a08b92"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f15af28a8a2db1384e7125f83f72d2f4be4a1598781b5a901c5bd13fe908a0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f15af28a8a2db1384e7125f83f72d2f4be4a1598781b5a901c5bd13fe908a0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f15af28a8a2db1384e7125f83f72d2f4be4a1598781b5a901c5bd13fe908a0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "143cf608014a8cbaed112b19c1c6a421148e6474d74bd96c8f2f8575b7866038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49dfe5730c8322aa370ca949d212d0e8d22a40a1cbb96f66198b8daf7a0c26d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdbab011abd3214426c65ef9bd6a0a941ad78abf15fc6786b0f9ce2722a892d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end
