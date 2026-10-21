class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.22.6.tar.gz"
  sha256 "315aae57c573e6acbab6c4935ca1cb47e8f52750fb73f1e297b0060325c27b1c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "685572ce57f3c84dd2315c1192d886d81b5c8c60d2b8f2701e3f893603d5ff9e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17ddb3fa36c188e1639de529a85cb562b12ce7c7df997b6b46f632364f384553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b27208b6684f5e8bec34a82543be608b6d6fd7a0905ed5fd7b6cc2f3c6c4df39"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "10f94a5db2b16d7dbbf193dfbdc5a9414cdc1a26f8c1efa8eeac0e94693e7169"
    sha256 cellar: :any,                 x86_64_linux:      "c89bedc8068b296da4fca2c48e8826f0d9029aed7a47f3a72cf77092f7f4b739"
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
