class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.18.13",
      revision: "a9b2b82ae04e7e6d91b3ac2723d01491efa116db"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e70378d7871076df066e9c07da2e59bb2c583afdd0c80534c11cb415d6759a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceb293ba2537da16daa9f6ce6c0ae3d04e766af91012fd3cc674a1e971fe74e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fee51697c7480deccdaff4855bb69d4e948a8c8098040c7ae94100f22155dca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e0cabca1f8c2fe05a187f2a5e6ab7954cedcc3f7e63be2e4554a596044b6902"
    sha256 cellar: :any_skip_relocation, ventura:       "caffaeb79c22354ff4239d969550f4587e19e35692a6ff3c449c6de1606b3781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11edd5cf78eb15f3f1e4f472e40326dbab3bc5f35ad2c55bb800814a35d597a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807a73c219f2ac86ec54f59d4e333be057a63ff84b34e617d00f03e67e90b671"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
