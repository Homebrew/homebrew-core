class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.22.9.tar.gz"
  sha256 "a66b54468dd61d2b4e98557655eb91865d39d198a7dd2c42286e8893d6af1d43"
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
    manifest_sha256 "ad835b8457d0130ca9c2a58c678f9dcfa058ae6221bec48e67c6259c0a545524"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f16f49f4c5f8082434ae1576946a80b643d326ce4df4ab2d76239cf47e46ba72"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e9c8b0a4482ddad5a6e0013ce6f643f2699904d833364262aad8c4b405c04ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "292d82028970e185f90e31f1a7d63ce7058fd4ecefad9fb3a43c0bd1697a0cef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7d7d57c916d0e76f36d0c0051b0e5743adbb216ab473379769c1235c21ba0d3"
    sha256 cellar: :any,                 x86_64_linux:      "e78129d740d374d764abceff71499cc3fcc68442361cb4a82e8dea66a26101b4"
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
