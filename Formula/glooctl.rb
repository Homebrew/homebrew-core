class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.7",
      revision: "3574d226c5ae8ceba1decffc4089fd41d8797c69"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77646b8e8fa67ed710557ab992d68336447a548548ceace5d53087e42edd45e6" => :big_sur
    sha256 "e92009aaf0ee7e74ab6bec1d32e0ed31d21d454226477b0f164fabe5001e5d64" => :arm64_big_sur
    sha256 "4a73a8630f7b1b8621b6d7cd62c136a942afd58aedb276aaa743b8bfdc126dd7" => :catalina
    sha256 "371bf88a460e06ba1123d811b6daf110d01fae1c448972551b5f7aecbb6e110c" => :mojave
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
