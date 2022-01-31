class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.4",
      revision: "ed4ab3169c21cee50a094ff0800720fa3847abfc"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "665f15c79341ec7bf9257c21edf02d1afb98d50fdac81ce156ec7dd563a7128d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85eda9fc09c40a0c33f253491c88a2db8f27489e965e6c9fab9bf5f367da4548"
    sha256 cellar: :any_skip_relocation, monterey:       "f6a8f2667a6b1b1a5d21dfc7c217a09d4b595f68acc8abed75a625aa7c566d22"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cb515a7b8d54d6e676bad60af7ab2b156091f6022e293d2258ec1f2cd96e93d"
    sha256 cellar: :any_skip_relocation, catalina:       "62048d581fddeaea1a0f3c11ddc2e460d2ac1a48b904425b08763d381b25190d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "456ba5a8180ad3f72828615966f01564883d781553ee98ff5bbfdfe6386beff4"
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
