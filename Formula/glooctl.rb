class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.15",
      revision: "39d9059b4aa575d3ed186460dfa6254eadaf1dbd"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4498a33e2bcc477c1effd9051c1ca94a25eeae56fb8a1287a0a9d6c8b37f1d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74b4150bc2178a89c96a7171bc33c924c9741968bd1010a750dd4c8df507f673"
    sha256 cellar: :any_skip_relocation, monterey:       "924cd0f02e6272733a7a25dca0105d7eba102daa332828a470794eb73a12b364"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d0edd4f2b60296910d3518f3bd53c2b5de0d5436e5ad4d8dc3b4a7589451d36"
    sha256 cellar: :any_skip_relocation, catalina:       "f549fd05f6e35f7d9799860ef56bd385186257111621db0cafb31515c1792f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce5d72a19923d3aed76e1294fa1de233553665197cebc90f287bd90bac766bc"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "TAGGED_VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
