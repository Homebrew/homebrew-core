class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c5bfdc31048547b2e6918f7e595f343208bbae9da3bbc4aa68195fd58b5472ad"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1dd77ffa9086853ee33d1b1640459a78c5031119106a0943f7e8c9903c6a5d3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d47d6e8d070feca3520572d175bf544993d9b11b0bc9a96311346207e812ffc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "518e774f5bfe7ddddd2d26714fecbc853909b10951ec79d2fc132510a8b2829b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d627cfcf237cf53d64ed3a8e4440eec9d1b5f222e07dd56aac2ccfd1eb0f9e2"
    sha256 cellar: :any,                 x86_64_linux:      "e1edf35e1c1166db771e0f88a0a5b8fa9feb27e6b4314f974442fb1285fb3d64"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/gcx"

    generate_completions_from_executable(bin/"gcx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcx --version")

    system bin/"gcx", "config", "set", "stacks.test.grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "Unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end
