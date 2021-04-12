class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.1",
      revision: "7aac127f0576f88ddf3ddaf706fa54c999041056"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e025f52334eabd7a093df89490bae170117c98fbae55b13d784e89963c7bfb8e"
    sha256 cellar: :any_skip_relocation, big_sur:       "afa6b7c618de4743a5badcbd64a7dd1dce4091854409bf6b57e850aa4527013c"
    sha256 cellar: :any_skip_relocation, catalina:      "90af3b163821c206e7c4b611ab8b2b532c01c52b202af1f07f734895f4f7c4bd"
    sha256 cellar: :any_skip_relocation, mojave:        "514e13a8d53a8db6d3d169ac286fbe3abf698ab51ba38c6976e8d980077769fa"
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
