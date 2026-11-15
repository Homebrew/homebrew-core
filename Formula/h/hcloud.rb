class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.70.2.tar.gz"
  sha256 "0a1de1b3f2b6ee7a1cb45b482d4fde6d88d555fe5e93894d551910987e959542"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "68a9be9f4756c6e0c8186b285d151da98260b1b42b93e7c661737f0b0d906fb1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98d4dbdb27421a11d7937246839ac25f025c825ac74be959fa3782ffa71f2176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad04df98959f15f3cb72455902e47f764c1b54bd2abeaf1d0bacc82aff18b06f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52c8a3a969d4a3ad88fa7087f8b994b6d1e2753d7858a568e829e0938b0132df"
    sha256 cellar: :any,                 x86_64_linux:      "caef1cff9031ae00b1b1f34a96481b1e501b0e7a5a1605bc5c85a8d80fabcf2f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", shell_parameter_format: :cobra)
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
