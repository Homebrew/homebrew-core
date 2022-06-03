class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.13",
      revision: "0621612abab3a61e220fa320eee925b1fff11440"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "014ec5c0416ee41bf5076ea4d30d608ac032465ed5ce150dadc3532a00e8ace3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a16b8151d737c290a4304b050c512de2d8ff4746f34ea1928abefc3b9d117c4"
    sha256 cellar: :any_skip_relocation, monterey:       "9debc422b02ac733045cc8246566fc22a52bbefa5bdab3871312359390987f0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "58405ae29fbca443b7021e60d6dcec9a5461d2584c34136a7e58047741d949d2"
    sha256 cellar: :any_skip_relocation, catalina:       "1e8bdf1bd727d972ccc6cd814b940f1871bf5a572a6956a3d44f23afc2e1b461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c552d980d71c666d37407f79c4d5485a4f331164c9e994f46e5ff06d21fdc2c8"
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
