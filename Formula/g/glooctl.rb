class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.22.4.tar.gz"
  sha256 "e3d4115038ac63e4fe2bcdfc6b6101c5620be2202c4fa170c07a336605a66fe7"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubReleases` strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6cf1d8db12f284324b5d4a0b7de00f4d7a5d2e74e7bc0afc0aef764723adc17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f740df0fb7141d060daa737644f9999de7d24c15662cbb80ff401f0362c9123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8cc4633ab06db2164dcb2cf650d8ebe60af6bbe9a4dd15daff3d2d4d5348310c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3d8c08896c5cedb581b0fabc1b805a8259f9d6bf0f3dcbf815e8f7ea6559757c"
    sha256 cellar: :any,                 x86_64_linux:      "f44a3ee6f875262742ffb9d3e495ade60bf6af4f1f56ac73e2c2aff3cc5d2857"
  end

  deprecate! date: "2026-12-31", because: :deprecated_upstream
  disable! date: "2027-12-31", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    ldflags = "--X github.com/solo-io/gloo/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./projects/gloo/cli/cmd"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", output

    output = shell_output("#{bin}/glooctl version -o table 2>&1")
    assert_match "Client version: #{version}", output
    assert_match "Server: version undefined", output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", output
  end
end
