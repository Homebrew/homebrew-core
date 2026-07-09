class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.21.11.tar.gz"
  sha256 "8cdd33ecf33c856540630ef5672026f72662bda170ce0f03f2d31360debd9c97"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb28f7a49552948929930e39f33824c2c8efc4130a766e4f24882d765cc9ff15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b507ba761c57eab61004ea35d0a3226360bf8297585698c68a66f152cc0eb89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d789b73b666ba88ecde3a023029f5b198eb5effd8fb597a701644d60e84d890"
    sha256 cellar: :any_skip_relocation, sonoma:        "9783f6dc84348f5c57b31537fc23dabe2f645dc98edf3a6fc1ddb4999630b1d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86e8f8517912bdc0d6018650d56cd7324c24457150e50de9bde4567936a7238a"
    sha256 cellar: :any,                 x86_64_linux:  "c0cd69849d403698e3f3c1802323935ec3b0420600ac1ea6386342b3323b460d"
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
