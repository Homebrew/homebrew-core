class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.20.tar.gz"
  sha256 "22e8884a9a12c64b6ef6621e7da56f6abfbdd674c7244eb8520c3a1d65b68457"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "e8b590ae2508dd0d6c3b09e8dbbd870aaf9e0394538f164aec5da559e9942770"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f993a6cc5514d97e194ddb1d8f22e0865560306f80c7b12058cc0f8a635124ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f993a6cc5514d97e194ddb1d8f22e0865560306f80c7b12058cc0f8a635124ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f993a6cc5514d97e194ddb1d8f22e0865560306f80c7b12058cc0f8a635124ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71e496084e8a32a8b0193014d449a79cb94bce7535242e724d8ab98ece5b5020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8a0222d65e35dc67cdc9dda13fd0ae6b98259119a56772445bf68e6ad3b3f33d"
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
