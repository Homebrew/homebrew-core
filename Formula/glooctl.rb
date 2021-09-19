class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.16",
      revision: "641f96cefbd45f2dd2b9906f5566ea6508f2fb1e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2bebc29273296f2ab1082b379e3b5a86427b7a03d9ee4a1b7569f8a8b5336070"
    sha256 cellar: :any_skip_relocation, big_sur:       "04242d416d3feac99a9ca2a02c0cfc04b9a0a42dd51a3203ff60195bdeb1f67c"
    sha256 cellar: :any_skip_relocation, catalina:      "03ef7e73c28e17b09dd72ddaa896ce9c1dfb43602a21bcb7ef2d0826d459d066"
    sha256 cellar: :any_skip_relocation, mojave:        "506ed06c58a2861047d003edd80bcb50744d8660dbfc2e48da70546ef8ebf030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea1cb15033955df0e9e560bc64951aa283f0a34fec7f36b6e46b28914932455"
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
