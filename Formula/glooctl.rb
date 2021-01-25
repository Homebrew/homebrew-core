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
    sha256 "ab5ca11e8865e761038450258d4aa88aa0f709f015fb84f9a70d4aec82f08dc2" => :big_sur
    sha256 "2f88e1ede791ce0de6f0c2b4ad2eb15ab3adaecaebcb92595f926971172a6b89" => :arm64_big_sur
    sha256 "49c126d354c42cdbf34627736c0d466af1453bda164919ab505e942e8b20000e" => :catalina
    sha256 "aee3778e64be2e699141dc4154863c3d61155402007cccd6e30c0fdd8cc22b9a" => :mojave
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
