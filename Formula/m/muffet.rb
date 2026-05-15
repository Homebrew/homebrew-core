class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "8d96e961942766faab47d2668943c619a446d690ee9bdb2083dac9d8bc6de692"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9190b7aa8ce13c2b8d2681143a93c092f689d2972a747fc32c0a88e2c7ed2f67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9190b7aa8ce13c2b8d2681143a93c092f689d2972a747fc32c0a88e2c7ed2f67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9190b7aa8ce13c2b8d2681143a93c092f689d2972a747fc32c0a88e2c7ed2f67"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cae17beaa8caf1b4af10db35834c160ef690e3c98209a11dee22a0f13a2805b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1233e31c6b26adb580ba279c78ad97e4eb9146ada9d6abbcae0e99c1186aeb96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebde8fc53333f41a9fae3d7572a092fc8cc276718a566e14126ea829034d6313"
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
