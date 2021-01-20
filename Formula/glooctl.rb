class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.4",
      revision: "48c27d71d62702f9831308eb982804bc1305b94e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a8513ce1c76bdd1f24a1f0e9f6e1f951955c7208f65b4d482edf58ab52d01bc" => :big_sur
    sha256 "4af80f04b9eca9372c5998aad61ceee8238ee169f0fc3c4777bc1c6df66a77d8" => :arm64_big_sur
    sha256 "14dc3f870c1e1834788dfaa21c883bc4caba324ef802b712ebbcba76ebfcb657" => :catalina
    sha256 "a8a2d31a3aca89dea8eafba276db50c6f9dfbc704e4c447248600af45b341b22" => :mojave
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
