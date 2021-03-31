class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.19",
      revision: "bbc5c3b4edc47deae5dc2cc77c4ca48d5639bf82"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb4d6690ac6aba67eaf1d49cd31a0608b9053e3125a2e8e7faef2370fc2de9df"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5f8079a0d2c354b8e840c1a56c8da3d02a2bc956338e5778873d8c60c44dbb9"
    sha256 cellar: :any_skip_relocation, catalina:      "54f93e89fc08c0ab5bcb9468124fae94234a1c7fd08cba0e6643acb43fdb566f"
    sha256 cellar: :any_skip_relocation, mojave:        "d10bc2fc51f0d5bfc4837dbdae38618ebe8087c9b7725c4c5a30eb2eadb442e0"
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
