class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.13.tar.gz"
  sha256 "f8d497716322a98a0609133c7f6feb94afe0185e879261f6569cf31f370d07ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc0cb37fd595c0f125dc8f4ae13e4836c8e668d2a9b0c669c0229f81c8cee0f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc0cb37fd595c0f125dc8f4ae13e4836c8e668d2a9b0c669c0229f81c8cee0f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc0cb37fd595c0f125dc8f4ae13e4836c8e668d2a9b0c669c0229f81c8cee0f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa27c2c272ac8c6d52d4b28104a90ef62a60100191a8aa78c546a5fd0858639c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c8ff56517b4284f3f2398dd4cad5f1367e07531a45397285e033df6ef205ffc1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
