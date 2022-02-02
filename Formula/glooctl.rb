class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.5",
      revision: "f6a9cc2ee2670b3d5893a426cb9514827a9686e4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b975a7835f504bc17c138cda7b5e9089b1f9dff7e835baa8294f5a88938009a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "828af3d8363e07a10d56ed6a2280e64020d075c54fbbb25995a9651c207f973d"
    sha256 cellar: :any_skip_relocation, monterey:       "faa310f27d0fd5feacc0bdbb51e871530f4019c5d8b19a890b559f929af77e6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "25888d7330036833c2292f62892b51dbc77d48f303d916589cfa598c261d3943"
    sha256 cellar: :any_skip_relocation, catalina:       "0ab3b02b178ef9cfa8bc739f9af6bc138cfea1ffbf5dec32ebb5292ed4f6b1b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dd2a5e4cebdb74c194cdb771ed9623ca0083141b7c11fd8ecb9c0dc03c25815"
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
