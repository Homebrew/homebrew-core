class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v3.1.5.tar.gz"
  sha256 "8658307013875044ddb023b5cf221085b4ecdfb3d093929443e636b8d1817e88"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bb60479434b47f196bd4713bfc4920c9440a159db3292d7f49b13f16925061e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bb60479434b47f196bd4713bfc4920c9440a159db3292d7f49b13f16925061e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bb60479434b47f196bd4713bfc4920c9440a159db3292d7f49b13f16925061e"
    sha256 cellar: :any_skip_relocation, sonoma:        "86496b736075f601b3b8fdc1da19a5b7e6475e1ff5403f306b444e073c6ccacc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b4a63228c2a4d1cd0a3e7a685c262e0522a9d4e332fee5dfb9ba4bb4bc6b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f489b3882af86fd29b39b39e4f3d44d3780c1ec20dad9bff964964c7bc91fa3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "Error: Failed to list store contents: operation error SSM", output

    assert_match version.to_s, shell_output("#{bin}/chamber version")
  end
end
