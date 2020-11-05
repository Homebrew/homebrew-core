class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.5.8",
      revision: "7ff1ef0596db475b7438d9dd1b60c2c148368221"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "133207450470ec5decceb0b5f1432504cfd8aa4017815fbbd7e3327302eb7fda" => :catalina
    sha256 "a5c8db4a0b19b58b4e81824af09857d9feba63da5545cc15557528273c2813f9" => :mojave
    sha256 "c308001c5ead132191ae0a1de53f986107783f590a309ea916e81ec0e0d37fe4" => :high_sierra
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
