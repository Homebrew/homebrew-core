class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.16",
      revision: "c0267d4e2c01a3e559ea33d427848ae6968723c9"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c82c16f5aa818fd54fc482bb864c6076a8e828af1b0af0e4fce1e813aa4fc002"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "597fb685f8ee44938cb821f195e504fda715a365d9ee71b0666176b1a888bced"
    sha256 cellar: :any_skip_relocation, monterey:       "4f51025c1a032fc4cff58e14118fcedced7f344916bbf79bd47001f9c5c05f22"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb474cfed4350e67a3f0f0cb630e1570f2be5ac512bf1adfc52c3ce4a13d3737"
    sha256 cellar: :any_skip_relocation, catalina:       "29be3a8048957db95e1726cbecdce68d6095dd6843d33f6efcfe713bf6127f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f84159117052a4789be7bc8a29fd037f921534747da2ad848f727044ec1aa43f"
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
