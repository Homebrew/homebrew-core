class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.10",
      revision: "5c93fb31bd572a1cea4a98c48e3b707fb65de984"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "199a9d3a800a1752d3cc09eb56dd980bacff341795e5f4a712878d961dd4335b"
    sha256 cellar: :any_skip_relocation, big_sur:       "6368de2232f03b8aa7df4d04d21e8d6b3da7e515bd7f5c52c67648e3b42e0bbe"
    sha256 cellar: :any_skip_relocation, catalina:      "b7cd2a62c8d1735b9610d0b8ab797ad9c048749948b34f0e9b4e636b0954cbd8"
    sha256 cellar: :any_skip_relocation, mojave:        "334de24ff4ea9359778e4a3ba16cf07a1adac6dbcad730f656811196da2512f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81574ab77ecda94b86097ff7ac79ae66b6b28ec47519da81ade602896f0d2153"
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
