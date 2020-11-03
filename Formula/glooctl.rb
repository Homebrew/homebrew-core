class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.5.6",
      revision: "3de7829cdf06229c8ca634e82bc451358265118e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9fdd0a52063655f1c03082c0744b76055ea3048676cc81c97069bbc973e5587" => :catalina
    sha256 "005c4e989baa46d3c6907b9429a24ccef1d7a6a5e49f15f06095522ef5b008be" => :mojave
    sha256 "c893ac651d0dad90d87e1fd5338acfbd22a5855c9182d3bb4019a78acd6d07eb" => :high_sierra
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
