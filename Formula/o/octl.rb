class Octl < Formula
  desc "Modern CLI for Outscale"
  homepage "https://github.com/outscale/octl"
  url "https://github.com/outscale/octl/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "48227f33d83c02f9b688eb965e8c7d8c1718a89545d7b3a1ee4968112357e718"
  license "BSD-3-Clause"
  head "https://github.com/outscale/octl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba9a288d8f042eded35c8b66438ce83d2eaf01a15486053b5ee633c3d891832d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f176d454bd9148e9b4b6a58366429ae10b6e6af9f756206560a7b0249a88529"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75797bdca7836e2b26b9902ab62139b87dbaf3704d8b22b9d8e4e7da7bbed8de"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7c35411337ec71821b9d1d2bcf384a40886c64d2434e916f99847e3ebd88548"
    sha256 cellar: :any,                 x86_64_linux:      "0d82b77f9d561d492c8d13f255ed35abd4e2307c71b0b23eac1cb1830dcec97a"
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
