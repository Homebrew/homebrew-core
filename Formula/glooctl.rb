class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.15",
      revision: "fc72632fba84c07370bb928f503fa40a6b9da6f3"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6871e9ae558b5173888a467275629bda7df74d6d8279550782355de2c64d1651"
    sha256 cellar: :any_skip_relocation, big_sur:       "40103151ebb256f22c14b712d3cda7185ed8fb263b3a8789783b2c0e09f09c07"
    sha256 cellar: :any_skip_relocation, catalina:      "bb04f88f811967cce10ee514ec7b12056ab0a5053fd524c6038f6fbf6e3f57af"
    sha256 cellar: :any_skip_relocation, mojave:        "8d239caa19a19ad2f0a0860e10566dd18bc4fabeb70f8170238534abad9c3107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd7098c9f1631660f5aaacf49d48bf6c7ec3704ccfdb6b004bbe56feab116e22"
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
