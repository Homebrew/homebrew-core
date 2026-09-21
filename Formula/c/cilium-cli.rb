class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "afdc484e06858349b69c3deac2f25326fee06cada31749195b22461b85d35c7e"
  license "Apache-2.0"
  head "https://github.com/cilium/cilium-cli.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39665429cdaab9f6ccdc4efabddda10940e68abdee68a8edc701d647df43e00e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f5ecf74b40e705214e6703b029e46d4fc9587f1f06b357f934a67ae68b436bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f0af84735d655050137e1bce823f2cd622eca1a05b8b2a40c0fd28b8aac604f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "70b1e8f05fea717efe56ae680e128f987bcaaed7317667ef1aca44c794d6724f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "29977f59f500b770e6614f15599a0a46a7157c646adfa09d4e0fb6f1b68d089e"
    sha256 cellar: :any,                 x86_64_linux:      "84d6729c9adc7b15398296d5d560cfb0c3cd1bd4e3255d7c60bc3513e4b44105"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=v#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", shell_parameter_format: :cobra)
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
