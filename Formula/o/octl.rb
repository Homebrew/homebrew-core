class Octl < Formula
  desc "Modern CLI for Outscale"
  homepage "https://github.com/outscale/octl"
  url "https://github.com/outscale/octl/archive/refs/tags/v0.0.33.tar.gz"
  sha256 "e643ca3b947f37bae273b2aa3ef08a3ee7ad0408327dfd00fb6363a7e6a0ebbf"
  license "BSD-3-Clause"
  head "https://github.com/outscale/octl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74d4288f966610a658dcf40cd33fc1bcb9019436a3879cd96952b9a1bfdf0cb8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2d04f1bffa92ff7c26aa42f9a0341b8a1c26a3532d9d174277665431a8b3304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc74ecef4c2a27d19217311af1a9cd294784dee1f1ddea63ecd951d71107ef59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c19c3cee7a1e6b86f39572ee6ea1e3f872bec85500d58bd61c3bfc8352f13162"
    sha256 cellar: :any,                 x86_64_linux:      "b376a4b17f9795067f2d7910c9a5331e0219482a51296f27d5990b7f9a36b9e8"
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
