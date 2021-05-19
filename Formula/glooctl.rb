class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.7",
      revision: "309aa1e49999348b65d82f5304977e271ba8f914"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76992c0e9163202f8db55a41b18beff15a7faea82b1ff8c41bc53adf94872b04"
    sha256 cellar: :any_skip_relocation, big_sur:       "758fad0be19ec993dd16e7d92ab3dd87701f862e426d443793ae484d0b992ffc"
    sha256 cellar: :any_skip_relocation, catalina:      "576728d8504874c868b0470448d341348e604f5f4100f8b0ae66ffda437a3f41"
    sha256 cellar: :any_skip_relocation, mojave:        "4fca6467ba8a749eb9096b91b06131f9ebc3d2273c0269b3a3c3dc49f883529a"
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
