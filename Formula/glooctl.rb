class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.3",
      revision: "579a2d9b795f826723062df6b1ca58a73fc36069"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a64cae9fe22f7157dd54a4adcab1796c8396791c007d6cfc36cee710ff4f1ed7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "160d8904df9e6d0304d88baaba788f5f1cadce8b90ad98ff3c122d000067cf7f"
    sha256 cellar: :any_skip_relocation, monterey:       "c60de1bda8720345aeb9fda1552727f99bac4495f92b50afea2b54fb3983d3ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "21dd81ec24709942d613eb86b59381303d1b3c641e41de5f021c47fddd530c39"
    sha256 cellar: :any_skip_relocation, catalina:       "8c12770784548e7541870ce4fb0a4c7559e8b53a76149603b8ff6c023725f250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b029f1edf129bfdf2aeb5d7f7df88a0a7f61e5c1bbaa44295c689cdb008ee207"
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
