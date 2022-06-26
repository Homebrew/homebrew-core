class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.16",
      revision: "c66079e45bc3e9ee5bac933bc4ac080e22b8737c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41c14447376ca8eb8820660b3f26e3e998c9639a59b521965cca1ba73368ef86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9d2785e2062e620dff7bfabd3db3da6b403fce98e794fd2d0348fe319e183d5"
    sha256 cellar: :any_skip_relocation, monterey:       "b58ebb129b2c7ae00da593b0227191b61a8791c70b82d5f0701b5898b43c38b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fa9378a50b5a6c1f43d30111a5fa346db763c292ae327d5e99c8f0d2db2f895"
    sha256 cellar: :any_skip_relocation, catalina:       "a1ace8b1bfa0ea46bb95244c78fb65b2f6de7ca583a89e6357bf2bb5294ceaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "844f21fde4be9b0c98df08354ea63da8e5ead24032b596005813b0e43503224f"
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
