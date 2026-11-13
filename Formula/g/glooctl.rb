class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.22.8.tar.gz"
  sha256 "fd4b381c81a253bbd7b64efe5c6e0037f015a4784c023ae057bee3a9b5eec0cd"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "615fa9fe39e26129e5cb45091ca234a97a9631ce1cd086a3685cc2568cf6a6f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "efe5eeeac3b824ae354c6d7165fd165be85a6727aa86734c7ed83d0aebc9f374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6107bde6266fd82356d0b98218694fa720500d5f157a800713808408c4fe5d5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a96e4bb7414f1e8824cb2568bf6f5393ae70b05030b3cdbfc2195ae46d8396cd"
    sha256 cellar: :any,                 x86_64_linux:      "dcd352ca1bf00fa3bbf4bff861459b90d3de3227318163b89e6003b71e2d132b"
  end

  deprecate! date: "2026-12-31", because: :deprecated_upstream
  disable! date: "2027-12-31", because: :deprecated_upstream

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
