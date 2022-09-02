class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.12",
      revision: "6efcf1fa0c17245486c18f4db2890b40a3345a96"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe99db3d58d955a0210db2968164d5a3af04bfcd1b34d7f7b80f3ef25ad8c61b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ded63edc5b38d0685e2d728a727e2c6bd7d181f13eef8149b611314b95a3e109"
    sha256 cellar: :any_skip_relocation, monterey:       "b370035c5d35c2fd55ad582743907e810728eeaf94b0fad5b970ae3e851a6bf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a5ab9ed14d396a8c0d3bc4a5d3d11f8bfeaf6dac4f16071810e6cf22ceb4dfc"
    sha256 cellar: :any_skip_relocation, catalina:       "5d903d267c18db67e026a14c63a5aa578d384f386f9f8ca41d6a3beefc3c0e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab9abe65d94a6b73a84f40c27c13afdb1b828f4c80fb21c9ef07d554698ea2f"
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
