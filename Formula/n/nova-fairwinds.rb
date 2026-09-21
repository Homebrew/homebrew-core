class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.12.1.tar.gz"
  sha256 "8f2b1ed5886672a4b53399202a8614ac31ab447cd7c5c637462ebd8577295883"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f0e05c0c4741c48caf34c1163d7512f3c7d5445570f152c14e789968621e5e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f0e05c0c4741c48caf34c1163d7512f3c7d5445570f152c14e789968621e5e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f0e05c0c4741c48caf34c1163d7512f3c7d5445570f152c14e789968621e5e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "738f366cec2c7292edcee3aa63a6aaae1b2be95c8666d64caa9730610f8f6a3d"
    sha256 cellar: :any,                 x86_64_linux:      "2f3d8cd918faeff663029eb681ec6a65a9f197f88aca9250b37beec2f5fb5b26"
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
