class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.2",
      revision: "5f38bb0633ec05edfc0daf5730090b9ced5838f9"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72145bf229c3ca0cf91135eedc5594f304e7948cf9eb47ff7c6e55adc928e85e"
    sha256 cellar: :any_skip_relocation, big_sur:       "102559b1462822bfc07b636c1efb002a16d3d8b2aebd245cc1203a433701ffb5"
    sha256 cellar: :any_skip_relocation, catalina:      "3fc2578e380bb92392b36b1f1a29d81e2c2c909e922abc3c77dad7a139e6c400"
    sha256 cellar: :any_skip_relocation, mojave:        "198203692d66265b3552baf64dcf1c8ba5a12f77c4ead0691b9802879d761c6c"
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
