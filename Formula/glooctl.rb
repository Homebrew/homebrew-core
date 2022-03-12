class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.16",
      revision: "d48dfb63d441d78871bdad921fb1da94cbc86cb1"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39641c6c764e33e5eba1be1164406c3b308de8aa51ec1e4cbbd0865fa5a64d75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c3f6f68fb1023234c8b7957fdf1c322ae23d76bc93bc4947178a55390a0c139"
    sha256 cellar: :any_skip_relocation, monterey:       "ba0110e19322d690c19dec9706e7e5cd0ee1967b399b55c4079aa5ccf8cbc5d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "71501efdf859cd3912f8c6d49f2d586555c6262cca7eb8dcf247a64c2ace91b1"
    sha256 cellar: :any_skip_relocation, catalina:       "702e8a8e9dc33cb6faa30670ac2ea4b487a4dbbf375fb42e2fa1441c0ef19f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddc344f1f9aa71e63841f29b0199877067c3c1141ee1f848280e1f54c60dc0ae"
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
