class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "6dd93a38d65c522d610ec3eb73fc54138fba16817ea214477ad086c4df5759c1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a50a106b82dd09b6ab8e80c922bb039a4fc68ee7f10d6f2aacc8074124f8585c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61b9752838f443fbdcc72d7e0e843f64d20e2f83ad077a71fb9b8df367538896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0146b3daa7ef7db00d2023b011a2b3a25b30fcff5d2b8eb137a77d96f499fc94"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9cf082f069802bee0403f23237176d55eb6e9a3f8b28e3675eae4cfa2efaae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58c1141e1b02ed9dac5d80b32d66d8295f408f7289d7c30c0dfaf9b3520cf0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "726e8098f0e93d1bf896f638fc23eaed87628cbe817d66665cb2b2de4a237438"
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
