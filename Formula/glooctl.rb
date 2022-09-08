class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.14",
      revision: "143037736c7a7b9f9318819a0465d99d54f89147"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c92b2d46d9a0d6f17a2e8fa49022375c22dd983300d23da45dc853d43fec676"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0786843bc7587755909b31ec814f44795d2fc6b076d791f002f69a0f74951a9a"
    sha256 cellar: :any_skip_relocation, monterey:       "90bc597c84bc68e005a9c31e632205ade9f8827690de2602c5c2796829e35a3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d830dba8e544b0879dae2021ab35ceefa917abbfe986f7a4059bd9c36850c96"
    sha256 cellar: :any_skip_relocation, catalina:       "79a952e97058e656fb095baa088258e2b932a5d7ba1b55b1eac876691d353856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a17be4e66d1b44f73acf63e44339f14a6e9d0eccac15e370fa859df94340e2a5"
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
