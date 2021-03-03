class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.11",
      revision: "82e48ca1e1c75c1261d7e05e57f02e34acb7c958"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd944c7b7cf98d4fc67380004ca2d76f034a43517330c533f88a56308a3d9623"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed4b571812943d8acda65393c3f5a267c24fd762edee061115496153ad040e66"
    sha256 cellar: :any_skip_relocation, catalina:      "cb3cee4780016a854c39418f33c623496b172fe4f176a372663ac92bd486ad01"
    sha256 cellar: :any_skip_relocation, mojave:        "8811e995dc3a45e8f61bc170012a0865c6ea1019567f3ad6e3059c9d559e5a2f"
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
