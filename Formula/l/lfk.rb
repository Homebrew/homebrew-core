class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.20.tar.gz"
  sha256 "22e8884a9a12c64b6ef6621e7da56f6abfbdd674c7244eb8520c3a1d65b68457"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "d71395ae777946b6fd236dc78e3b0728678091d39c0b4ea640df6aa8cd13ffcc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb7c3e90e6c71eb57e2edd8e515439d3519393e13dfee5effa207f2b1cf31f8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb7c3e90e6c71eb57e2edd8e515439d3519393e13dfee5effa207f2b1cf31f8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb7c3e90e6c71eb57e2edd8e515439d3519393e13dfee5effa207f2b1cf31f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7f4b406790b2482d67e5d9d33ba77166f440cd95926847dd6cd7ae340a599fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d25369f0511dc3a922e95e6b6779c4de89c2ff1024227bf5690e325a3acab92d"
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
