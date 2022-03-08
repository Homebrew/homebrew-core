class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.13",
      revision: "e8cf5bf4e2b027ac211bd1a807ac180c5f44d577"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e566cda58ee6006af4f335c38faea605035c3b297abe73bb3b194fec3f3f35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36f05df6f34b51d999b70adc3bb0b73f94fe5b4f72c465969ccb92a7c46a1f5c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4a1b1f0b1bf6d1dd6292ea84e711e457841c46ada9c7bc38011439a0c51020e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cd19ce97bf4b8a8b51da046d1d78d3ab68b7ad2fd8dd76958fb6bb1272c4d38"
    sha256 cellar: :any_skip_relocation, catalina:       "cfc8ddff7d61d48c1b29a8687c825ec3158867c999a8bc9f8d6facf303555348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32fc3cbf3753b7d3450d1c22ca1a45c3dce57436c32b0432bd6b5caf7de720c2"
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
