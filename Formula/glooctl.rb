class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.9.7",
      revision: "fdc18846c50326e0f672292336123653536f6d00"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deac274a4a3d9983938f04aed687285deb72a9b58264c7f1233c2fd29575ce85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4eb896737ba43bf0208d33c891c25e034871d8a4b2617e763c374ab70760482"
    sha256 cellar: :any_skip_relocation, monterey:       "38cfb7bcbe2cf26f089a0176df47dcc181a233b44f628586d8b061e456db19d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "47b51c6b4998a6cb9d0f0bf9122d25cc69ae8a4c405f70719e263c6e31b300d2"
    sha256 cellar: :any_skip_relocation, catalina:       "973a7e13914cd8a4210b39bfb22bef39b47204d0bbca0cff4633bec3c746d2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7018590221bab190115e7086063fe52f8033afd61fd1803d684aad57bcaf050"
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
