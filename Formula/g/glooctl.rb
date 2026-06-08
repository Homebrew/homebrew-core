class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.21.8.tar.gz"
  sha256 "bbed7b60ffc5a2c28a2fc8138243e3a7c31ddd17b84571295fbce33acb2081f9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44f7565ef1d78f22a52da05cfc6a2d3014ecf011e8f891f9a0b86b2480974e5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b23d0b6a6278f84b612356a6d80d08db33a837bf5f4d9d6c7bf2e55c7873fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98f8467add81cbfbee48b1ecd142572eca13432cb9bb207e42f021d142616ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e280ee8cef54e95287ebfb0168803825f5c054305d2ed0b164f77dee4272341"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39bbba4fb1406f1069eb62bbefff5dfbeb99ec9a0c8413a221451d8c693a9828"
    sha256 cellar: :any,                 x86_64_linux:  "7dad22f2479738bfed87768f49b8275cc8cd460c97632869fc11dc3064cbf4f0"
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
