class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.9.2",
      revision: "a5c1d816fe4c2259eb28ffd59b7f6e90e9cde132"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c64e0258031a898bb48b665516e2a2c19b63d03ccfe46810d30a3c20ec33d66c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4bd1b2184066684f78277dcd9e040579692ef478ae83376d2101dd77cec57c7"
    sha256 cellar: :any_skip_relocation, monterey:       "a3738dc076ed81a6a456308ad84b4d37c6f74ed33109ad906d8625f5d711bc5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "160b5fd23191c1c7f489ff7cb7f82280085440ba777be2cf4d5157f49f253517"
    sha256 cellar: :any_skip_relocation, catalina:       "259d5f8ddffe343eec518602a730490080350f3b08d122e1b3da34f1691edbe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78eead0bcd69cd4c10e3206dd18cc2fadf2b801d54370db519a5b8391ac32da"
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
