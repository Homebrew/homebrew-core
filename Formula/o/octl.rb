class Octl < Formula
  desc "Modern CLI for Outscale"
  homepage "https://github.com/outscale/octl"
  url "https://github.com/outscale/octl/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "77257a7a194c077d9d3acb65313b177f1511b3d090107d04ef205241379f842e"
  license "BSD-3-Clause"
  head "https://github.com/outscale/octl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1a04b8eeef2878c8ea65bf4793ffc55e8ceb9bb43136420203b398f4b8f2d03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ef7dc59684fc35bc7b0a197ba6a46eab85b191f4a32721039d2557a546b4662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca8205a0326a652d00434759c95d17d5ed1d77656727b82bc3153b3ce6291920"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c33a406f41d41e46714f004c62f2043eceb7bb77715a5fa41ac2d1a3f73aa77"
    sha256 cellar: :any,                 x86_64_linux:      "b7485e14a8a2297d8137ffa663f77f7b43fb47b00b5ccee4480cf2eadd25b3d6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/outscale/octl/pkg/version.Version=v#{version}]
    system "go", "build", *std_go_args(ldflags:, tags: "homebrew")

    generate_completions_from_executable(bin/"octl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octl --version")

    assert_match "One CLI to rule them all", shell_output("#{bin}/octl 2>&1")

    config = testpath/"config.json"
    system bin/"octl", "profile", "add", "brew-test",
           "--ak", "AKIADUMMY", "--sk", "SKDUMMY", "--region", "eu-west-2", "--config", config
    assert_match "eu-west-2", shell_output("#{bin}/octl profile list --config #{config}")
  end
end
