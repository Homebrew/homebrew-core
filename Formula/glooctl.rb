class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.22",
      revision: "7edf24a270f9a9abfda27b53094b3fbdc8e11a65"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44ca3c9c57cbcf1ff21ca0b8dfb1742c87540e0668fea9a5d05093c0fef400a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccae94c8acc52282d3b84247199c40300187600fd07d120f03261f3cd65bb77e"
    sha256 cellar: :any_skip_relocation, monterey:       "4ae572947696c1aed9cf6047cf38de1c61f1fde6de8b4d1ad109f95a6d0e281b"
    sha256 cellar: :any_skip_relocation, big_sur:        "287668b548281621a1137afcf593b7bab0797436d9059af97f3a082cda1c42c1"
    sha256 cellar: :any_skip_relocation, catalina:       "671e109748012f2a64ff9e28c0fa49ff9e9cbf8e0e06badbc9df76546378bec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a1aa9b40b368d662716a3c681343189fd386d2972e0bcf92b7fe0d3064fa4e"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=v#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"v#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
