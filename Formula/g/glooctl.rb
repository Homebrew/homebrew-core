class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "6aa2b6313694f74195eca0f7e0cf81ae65774272ec132dcdd5ef3125dce1c323"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5219d5742d85dc5071c19654a399f6c9e1e943d553be7c5ca24b74bba6346abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29090d0abc62f49b53a1f538a1f17eb16f292af37a6f12a9669d9bea2f8f8715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "008ad7ea2d26eabe15d7f694332247f747b3cd5d24b9bf0ebe6b96126afbd1fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "079f0117b62f03e764d8e4cb27bd1171ae62a8bf85bf61f2b641ba19a50bb696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f7ad4704cd1cb37559eabb6282ab2328a7baf0cdf2215863a40c31dfd8eb5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a77b664c726cab90ba7257a02e5c241f132c7dfa6b8918d88dd690305a0ebcc4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/solo-io/gloo/pkg/version.Version=#{version}"
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
