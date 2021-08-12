class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.6",
      revision: "30c39db6dafc243cc9b9e42bc949202262a2ecc4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00f79b8f6bacccffcc2160b3de1483c75f5ab8c120c71d7fe59446878c772ad5"
    sha256 cellar: :any_skip_relocation, big_sur:       "16779d00859ef2cfe95cb23460e210172823a8a09a30f515fba3a35cbd7b4a01"
    sha256 cellar: :any_skip_relocation, catalina:      "9fb23430bc53bd8f4995b0198a274e70c1bef0f5b2ccce14aa192b524740bea4"
    sha256 cellar: :any_skip_relocation, mojave:        "4e1dc577448203bf326a97543d21d3e664c3e4d94e3e95523b4e2dfa3eabf9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c602bc63077290390e29c243299c6daadd014f31b27645858539109065dc7c1f"
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
