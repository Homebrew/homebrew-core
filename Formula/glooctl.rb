class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.5",
      revision: "b0d0516ff077cbff6cfe2fc73eb66f72d7774bcc"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ecf6b81d2e567c919dbec77788f0883d736511219d6cb600910685db47aa243"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54d528a3ca7a3056ba7cdae03d9df85f4b89c57631bb86c075dd506e237ad098"
    sha256 cellar: :any_skip_relocation, monterey:       "262d8d848b19c69e322186fe160dd82fb00a1497f2c472a39fc7d4e2468f8afb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2beac4a6273010c1edb4cdf82b909cd4ac035e1df9f61f7f8262b0413260d0e1"
    sha256 cellar: :any_skip_relocation, catalina:       "7db74d0956008fea021f2b740c5d0f0fbca29706b05ca1aa5541ff9162e17647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d560265625c8c3a04c0e948c0a9974b58200c57bfdeb360c1c8a5640f1c07175"
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
