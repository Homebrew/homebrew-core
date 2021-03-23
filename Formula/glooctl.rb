class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.18",
      revision: "f52b5d29b1b54677caa617b6d335ac75f564dba4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c34e9249308fa19edaecbbfa41727e9101e6e8313dc0c85e88beff95192764ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "35989ca9781bea1e3793f27c4322ffbc7803be11780c7914cebd35f5ecaa77ee"
    sha256 cellar: :any_skip_relocation, catalina:      "ee840712bf56156cdde8b24e261456c14c38f82e12f7bf1404d041ab2af1d755"
    sha256 cellar: :any_skip_relocation, mojave:        "154e7c6bd7db31462db0ce64cc4bde70272fb50004420a48a44d3fe35dd4753a"
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
