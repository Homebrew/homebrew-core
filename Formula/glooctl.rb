class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.15",
      revision: "39d9059b4aa575d3ed186460dfa6254eadaf1dbd"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "611d661cb8a7d3a9475c402d997e292cecad3ceca857fa187cd89c9e65020948"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e0e7ee44842a0e3f3775b843201b4acf5097fcbe90ffc47f0d931509c2cf8f4"
    sha256 cellar: :any_skip_relocation, monterey:       "d181194f803ff5dca894bf5877163158b9d6a9f90927470f2677a9ab4725fb14"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa4cd49f1e83abca074f382f29f4598406b359033792809927e7102c36ddae98"
    sha256 cellar: :any_skip_relocation, catalina:       "f2f13cd1ebebd65eabde68a331d4c1ae4d182f1e1693110d2fdc15235cecfe5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a64b661d88330838e4cb6085f359df481acf60588ed316c796dd49ceaad96bf2"
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
