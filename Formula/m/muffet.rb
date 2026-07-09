class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.5.tar.gz"
  sha256 "73cf7bf9889ffb6406994cac3cfb1ef8f616d49f6a6c0ec9fc2ab3b1f50257c3"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc5c94d3ffa441723ed7654cff27ff52534aed6850120b70c739dc363c8158bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc5c94d3ffa441723ed7654cff27ff52534aed6850120b70c739dc363c8158bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc5c94d3ffa441723ed7654cff27ff52534aed6850120b70c739dc363c8158bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea0f1f9346e6670bb37adddd754c7efb2af5c735effe85c96094e9d6d6176f7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd7e3b047e943962fd3d256f2866741853274cae7a941b60d364a54d7a83952"
    sha256 cellar: :any,                 x86_64_linux:  "0ccb3de1d2a56a37ad2c869efbcd516f8e7dcfb2024dd6afa7ba18797226b5f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muffet --version")

    expected = "failed to fetch root page: lookup does.not.exist"
    assert_match expected, shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1)
    assert_match "https://example.com/", shell_output("#{bin}/muffet https://example.com/ 2>&1", 1)
  end
end
