class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.8",
      revision: "faf4c222fe951e99fefde46e55f2a8c2a7669b1a"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a0745ee80c106625df8e3c96a93f31ee76fe0b33dc29c260b1c45a2113ebdd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "746f72f0bc804c52245f64c0c8f5b8d35ca709a24f877e129746f608563a9617"
    sha256 cellar: :any_skip_relocation, catalina:      "81c5035b9fba49571a84bec6b1ef98ec06dd6a0affd5886cd4b240da5140dc7f"
    sha256 cellar: :any_skip_relocation, mojave:        "5ca566395a3fe05d0a230ab6ead0c6441ae4954986957f0994b77e302f66765d"
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
