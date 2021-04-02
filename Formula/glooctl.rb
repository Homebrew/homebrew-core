class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.0",
      revision: "7302956f001f2009c43bcb9b118b330990732da9"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3c5909adec22aac55f9b06508fd5f1e2840e39e35ca2e7de788fbc8225c6c70"
    sha256 cellar: :any_skip_relocation, big_sur:       "8883d87c5f4f4b0e8732bdc7bc2de4e2897bb9e8211b16a07d8643428c2b4b6b"
    sha256 cellar: :any_skip_relocation, catalina:      "fe4b48142829bd5843614ef4edbaa1c69eecc9af17bf7e6ce35faf541f4a4e1d"
    sha256 cellar: :any_skip_relocation, mojave:        "72e2b6520867e7544859367f6fc19d16d77ab10a8eebec5115bc1b98949981a9"
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
