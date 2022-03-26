class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.18",
      revision: "2ef965da75862ec63aa9f9eac2c46de2f8455d03"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56738561cf5a4b54109f4709f51aa2868a12fccecac6ad7d52aca83b92ef6691"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9648989470bab4328c0fd20b59ab3e271823403824de7358e958667a5666213"
    sha256 cellar: :any_skip_relocation, monterey:       "aab0cc885f3781a4db10e1d1d4976c1f43c46047ee10385a251210fcd67c1e0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "019d8c69755a3f8e3bad12ef7a67034aa7be8f151fa29000830b12dc136c7b28"
    sha256 cellar: :any_skip_relocation, catalina:       "0b287466960c9515be7750860264e5470aedb377c482bb5afb96a7fd4288ea2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7177f94df0afba983164a123466f3ab6591fe760f0028b7746683318331c6e95"
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
