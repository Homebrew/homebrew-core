class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.17",
      revision: "caa18bb8755ef5a3c235c293e90b7feb8f530991"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8d2acbbf1ef8359a34c3a0303bf02c6cf76fc5782d2c19c14e16d3806c29555"
    sha256 cellar: :any_skip_relocation, big_sur:       "9819280db673dce6f9506bc4e7cbe0c273652f962a4dcc7f4aff437a29ec76f7"
    sha256 cellar: :any_skip_relocation, catalina:      "d2c73a2cdce4716f55d968d82a0831c8977002f461c1afed7a97fd19e4773198"
    sha256 cellar: :any_skip_relocation, mojave:        "1b282299a3d9d0c582f03897bb2515507e7f3d9ff61660ad3686485b9d225a3b"
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
