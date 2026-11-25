class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.12.4.tar.gz"
  sha256 "0bb556e6aeb26a18c81d0b3dae7804b7c9aafc2ae2b5155b028de5a55e697261"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    manifest_sha256 "6d86b17098aeee5eec9636c9c56766ca5daa8bfa81ee71575c2c1c1e0d77ea3e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac7d25c2c3123d418ad7b50cf35caceb112cfdc222f25045a6b73f9a5cc559f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac7d25c2c3123d418ad7b50cf35caceb112cfdc222f25045a6b73f9a5cc559f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac7d25c2c3123d418ad7b50cf35caceb112cfdc222f25045a6b73f9a5cc559f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60d9808500a4c8a6c980063bb81507aeb562130afb90f1a22540d3346e2d4c97"
    sha256 cellar: :any,                 x86_64_linux:      "5ce7bf25f563e8c5cb7b0259a90826822ad92c9c0e5383afe62cbc152e934184"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
