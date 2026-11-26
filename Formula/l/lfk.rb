class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.21.tar.gz"
  sha256 "2b1d78a9c8190df2c15d7c4514883125d809d9d80598b51a6c7109fc37f19c28"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "924d2a98c9f85b25613b5275275f39da09d9afa4be24c7c647ce43b232395d3a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b2ac97f74bd7b427742fb110de7c03a2f84a627185391329e18934964104c1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b2ac97f74bd7b427742fb110de7c03a2f84a627185391329e18934964104c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b2ac97f74bd7b427742fb110de7c03a2f84a627185391329e18934964104c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a6c79e47921c2991b0d1c87d6ddf4af21dde95d4fca54a022724ebdbfdc71c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b00f4025ebfab953f2bb099c753240e7a4613047476a1a0dce5010ddd154a811"
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
