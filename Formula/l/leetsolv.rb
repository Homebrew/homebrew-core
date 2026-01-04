class Leetsolv < Formula
  desc "CLI tool for DSA problem revision with spaced repetition"
  homepage "https://github.com/eannchen/leetsolv"
  url "https://github.com/eannchen/leetsolv/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "430303725aed7340f70d09e2461a82806e9f8ee195a98b8f0af6f0fc09236cd2"
  license "MIT"
  head "https://github.com/eannchen/leetsolv.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/leetsolv status")
    assert_match "Total Questions: 0", output

    input = "test note\n5\n1\n2\n"
    pipe_output("#{bin}/leetsolv add https://leetcode.com/problems/two-sum", input)

    output = shell_output("#{bin}/leetsolv status")
    assert_match "Total Questions: 1", output
  end
end
