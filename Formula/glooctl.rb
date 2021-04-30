class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.3",
      revision: "852b1c95da17a81f5e8cd95722dd5c761f3da035"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b07af04101dd17c9b36d66084333650e67a330000496bfbd832efc7f6a205327"
    sha256 cellar: :any_skip_relocation, big_sur:       "edd878ffd2e2b91c8402cc29700e7b8630972a22785f3992ca1cddb66c031825"
    sha256 cellar: :any_skip_relocation, catalina:      "bc6c18977049b4c1c8a1e0a514fc988c3a1dac80d29ff2b2d044c647908432a1"
    sha256 cellar: :any_skip_relocation, mojave:        "8f1e79b59b651b109441563a195677bfba35d37489ba84e145b3bd8efb76c5e0"
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
