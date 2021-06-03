class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.11",
      revision: "09f446650f206c3fba4890fec6a5e39255a13c2f"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c37127ec6b3b6c0eedaf47b5fa13b3cd78c76aa39df46d5cabaf4f0851120d7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab821463a4eb76ef5a725ee75ed72caf3f2a653544c22aed98133bbd039b74ae"
    sha256 cellar: :any_skip_relocation, catalina:      "c47d6f0647e134daf2eb2061165f6a6c66f50eae2812daf3318c83d02671c58b"
    sha256 cellar: :any_skip_relocation, mojave:        "1a47bde142335a0caa945bee8603ef855f2472cc0ff380c8a259bb44c40bf110"
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
