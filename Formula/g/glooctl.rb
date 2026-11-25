class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.22.10.tar.gz"
  sha256 "af702898413c0c24f99e389b62fecaa0ef0219f7e9ba2e954c70b0653c0bd3a5"
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
    manifest_sha256 "73fe89920bcda43042700b4fdb30d84416e1958f100108a79943d80fa6aecd61"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eac96c250fbbcb7c8fae8607b07f84c39485598a2b87dd8e399ff7d10b7b8366"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c43e532953d3e63e203f89d4eae13cd7ec5c4da7bfa3f76621191a701456502e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c5a60b5bcce2feccf27b429d666b5004d604a180ca6279084b9025531b6f662"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "65476f158f75a09078dc37c7b69316eaa47a54f5e65a3dad5c648086c2180812"
    sha256 cellar: :any,                 x86_64_linux:      "62b25f36766f0bb948e99ba06172914204b8bc683b56192ba13efc56f501841a"
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
