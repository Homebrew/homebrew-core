class Octl < Formula
  desc "Modern CLI for Outscale"
  homepage "https://github.com/outscale/octl"
  url "https://github.com/outscale/octl/archive/refs/tags/v0.0.32.tar.gz"
  sha256 "976699774c888aeba68713519293ab4a5c1e1bbdb4dbb88bd48ab89fc8c44324"
  license "BSD-3-Clause"
  head "https://github.com/outscale/octl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3067b95c57cd91f0e4b7c6577dceda0aa9cca52cc49cc1ce5fd36c270c18aa55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f8e0d027988615bbb98f8e7031184aba8acdd797fdfa47fc037f7ca132fdec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78d508e4b2762729c5ee3ad4737a5b273ecdfcca400ec32f62cfe6066ecb30dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6452b0b26ba96723704c3f7c6607efb276694ca00a4f277b33f387b909d00ac0"
    sha256 cellar: :any,                 x86_64_linux:      "030f8d26c1d3444351baec4c4a22dc0210ac8b4e28113e80af35e0c845e7693d"
  end

  depends_on "go" => :build

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
