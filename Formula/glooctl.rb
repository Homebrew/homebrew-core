class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.3",
      revision: "34788b069998e478d6cb000ce95d0f6abd7279cd"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b17ad0981aab7350e88398b94393e47f495345a8933d3d73d355476f36efeb52" => :big_sur
    sha256 "56849b0bd78b3063440fe2aa8e46aa2821fb1513ed0b023df18f4756edb0fc7f" => :arm64_big_sur
    sha256 "b4005ccb6b870c3353ed718c1a73ddfee1275348fecbce4885619a251123e59c" => :catalina
    sha256 "9f0879cab1b55969fe6458dc27de4e057a169ee04befbb3134c5b8f76f011b60" => :mojave
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
