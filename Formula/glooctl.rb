class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.17",
      revision: "e9b062c0dd1472041de862cb93c7b480925e3757"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4d6003d7f5983346d422f1b4342b0f3f65a0ca21d5db72391b9df5d0e607ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2eaca0c5cba734e8291f1e11ec2bd9c99fb68a91bad0ca705edd2dab0865d937"
    sha256 cellar: :any_skip_relocation, monterey:       "d90bef1c036ff90b5461bd098065a488c77d427c8b80d2d64f7618ccfbb5c8b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb002135f239a4a3cea512c16a3f7c8999c0f10e84dc61fcb378820074699ccb"
    sha256 cellar: :any_skip_relocation, catalina:       "2b13cbf0e79b120a3ef68eee44ea5a284cb3c61e890258f2f715517adb998907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae03273b058ead11c5bdf8c062bfbff93eacf7d6d03b7c6e84fe34c8fdedcd3"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"v#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
