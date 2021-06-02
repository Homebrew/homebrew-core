class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.10",
      revision: "73cd007ba1c6b2308e3014d0ec1d2b651d504e14"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "608eb3c3a6501bd52544da7d1907686bda38880529d03ddee10b1ba1a6aaba6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "76bd127a1c6b929be1245389e51c941c136c1952ca8a790f94f37105f06f60f4"
    sha256 cellar: :any_skip_relocation, catalina:      "5945d29a5406a534df47645dbf8819c0f525f012d2e618119ce07c58b67da02d"
    sha256 cellar: :any_skip_relocation, mojave:        "166e90929cab426656ba4f16db29f116b328fd4e7f33ba6efb98e2abcda419a4"
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
