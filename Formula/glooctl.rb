class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.9",
      revision: "ef66036d1e44b765df00254d74ead11a719f6cdf"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b937f1f2599f85e69579c40022ee89aefde94ec1ffc36186c50b7b8872baea5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1353e2fbf4036c00bb044e46f0081c7e0043aff1639aa016224bdf06a9c1f5a2"
    sha256 cellar: :any_skip_relocation, monterey:       "748850cb53cb197f27de309d2df3a21555173072b8173b6c0496e2194d9df998"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6a8bf015d6a4e76a0b176bbe8620a0dcf852a637d8835ee2fb62269575ee6a8"
    sha256 cellar: :any_skip_relocation, catalina:       "2f96e0a531c5e7fc5c4deb39dbca7252fceccac22583d9a958862f7f40948678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fa48679ded594ecee01166567a121a129ec033d499fe1f5d3054b61d44bb001"
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
