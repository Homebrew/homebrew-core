class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "7f8f6ea60a6e0832776586970ef86568377a81032ada9b3b0434db73a7206ea2"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1a09baa01a02c165f0327153e2ab87ecb2ffa5fb5f022147e31e6e56a54241f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1a09baa01a02c165f0327153e2ab87ecb2ffa5fb5f022147e31e6e56a54241f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1a09baa01a02c165f0327153e2ab87ecb2ffa5fb5f022147e31e6e56a54241f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ba1971ddf59917bbdd0100d5deaa8a3cd08cfcb89d987ddc81de1585198125d"
    sha256 cellar: :any,                 x86_64_linux:      "ad23e3337496424be135acdc3f901bd9bedb96b70d0c813b4b18e7362550edd0"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end
