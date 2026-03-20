class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "cbf83979c7a257b22ccdd9f102eed3876e237f699e3279602269ac635d728ff5"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb71acafe9cd0f03be60e2a870046c7ca2896aeb138334382e66c4b4a14f8953"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb71acafe9cd0f03be60e2a870046c7ca2896aeb138334382e66c4b4a14f8953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb71acafe9cd0f03be60e2a870046c7ca2896aeb138334382e66c4b4a14f8953"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f4cb0df2bb0b46e9e8d398762c4cbbc4f1e0210b07bd3de1dfa2588cc0a1526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24c3ed122b0b527b8310e31e08e1756782c25944a2f8275c367ecfc7c23ddb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889b6520680af87d4fe7f843d84cb6f07680cf0b531ba678ebb4105b7a253756"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muffet --version")

    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org/ 2>&1", 1)
  end
end
