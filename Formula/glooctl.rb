class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.6",
      revision: "b5c962dcc12f7d1dea2a87a1e9c76e3bf021572c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96d240cdd858c80caa7269ebddf0fb29415a2398fb53008b4e11834fe2a0276f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "506d073a6813ebdfda76b6db2829080fbaadea7c9289c1d9eb4111b9c7827d39"
    sha256 cellar: :any_skip_relocation, monterey:       "371c4cabb6b47e00d6863488101b1b3d4c69fea54f402b5b28b1abfc01f9ec6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "057588d0dd2226a0b64da7990171ebfa78b399281211caf17b923b50369928a7"
    sha256 cellar: :any_skip_relocation, catalina:       "7dfa80e103a26e64677883d51b3e5fd44fb27487e0b9422f599958d780bee664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d816b2242f327e031ff9cc94a5cb0c7e5934c64c8a18778b3d38afc14fa963bc"
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
