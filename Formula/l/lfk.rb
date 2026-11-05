class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.15.tar.gz"
  sha256 "93eaede773da47f702e5f48fe766bd12d8bd01191617bfe6732c9d4e9593816e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b63f8e38b0fd20dbe13e63ac42444fc7e57d59cc2462c5ebdb0c809fc3ebc45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b63f8e38b0fd20dbe13e63ac42444fc7e57d59cc2462c5ebdb0c809fc3ebc45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b63f8e38b0fd20dbe13e63ac42444fc7e57d59cc2462c5ebdb0c809fc3ebc45"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec01feb19e934a11fbb171513d6f572326e8fdf736896e214caef1bd60a110f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6d5b089d4c8ccd6f0716685774efaad3133db7908f7eded54b218cf1f4c2be71"
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
