class Leetsolv < Formula
  desc "CLI tool for DSA problem revision with spaced repetition"
  homepage "https://github.com/eannchen/leetsolv"
  url "https://github.com/eannchen/leetsolv/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "430303725aed7340f70d09e2461a82806e9f8ee195a98b8f0af6f0fc09236cd2"
  license "MIT"
  head "https://github.com/eannchen/leetsolv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cd16d7e328e6be2865e869e531fbad280aaf9d565cbd77d60ca153d9515e741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cd16d7e328e6be2865e869e531fbad280aaf9d565cbd77d60ca153d9515e741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cd16d7e328e6be2865e869e531fbad280aaf9d565cbd77d60ca153d9515e741"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba4f532844e8f23dca6e5fb901d6c927f02af3a486140d84b097eac0e7e30fd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35f24022b721e61cf39758a0e5105530892b3cf047c992c0d3bc1752306560b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b083ba517ea479d21a851ffe66daceeb97cc86a1b1759716c4d737495eca783"
  end

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
