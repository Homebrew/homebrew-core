class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.14",
      revision: "a548ef23a40a29bfe70ac2d4c749953af30a3cb4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a58c5ed92953b722a0f2bdbf3e8560157f70420589de0e0b1874ac169c6cabd"
    sha256 cellar: :any_skip_relocation, big_sur:       "639ae5471d420ec6b68ad080e206103771280bcebc22d9095b9fad589adfa415"
    sha256 cellar: :any_skip_relocation, catalina:      "53a35f626120b51b04a3c419172c37ed5e865b88a1d1bbc5319274b6b2a786ff"
    sha256 cellar: :any_skip_relocation, mojave:        "8c3fe88f9234807b62c008c3ca0575e7317b4a4331e9c36978038d2e75276383"
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
