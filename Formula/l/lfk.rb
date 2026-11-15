class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.18.tar.gz"
  sha256 "f0183f42ef4a86c082cf3fc5e03f65f2e27aee2019585bfb427318deb28b8b6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a54a0780c07b058ad755b819a57d6cc295673ce29af76edfa1afd1551c64145"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a54a0780c07b058ad755b819a57d6cc295673ce29af76edfa1afd1551c64145"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a54a0780c07b058ad755b819a57d6cc295673ce29af76edfa1afd1551c64145"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27355975a7ba5f4868903f450b8cf49ab54d066b6a4d271d86817afffeaf77da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6e03a70479e083e6bbc90a7a0bad9a5421be9cad6258f8bbe1ed98909b755329"
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
