class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.17.tar.gz"
  sha256 "23f92bbb405951a6cab8f6ec1d5920eaa9e5c5e731f6f04a955abdd3cb210f5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5e1b8be922161fd814b0ebcd9a29f35d62f5316a4fa04dd1437f4514938b6d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5e1b8be922161fd814b0ebcd9a29f35d62f5316a4fa04dd1437f4514938b6d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5e1b8be922161fd814b0ebcd9a29f35d62f5316a4fa04dd1437f4514938b6d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0633d8fd9f65d55d8ff66a0d59be6bf69795831f56e1b49d616ae9eb94ece899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f98c1fadaed64cc264e1a256d4294069ceb68d4d0a40bc17617710d876c13a00"
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
