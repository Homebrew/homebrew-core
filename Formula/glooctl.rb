class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.11",
      revision: "7486f9763be1b388bed254759e0a23973d7ec430"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "759d1b56362127d8cd5e38d6df8110766daf06380ad378615f4ef3498a3af054"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb5bfc3ca8687652debee4f35d66de1182c399ff2991d309546ff48898aa37c5"
    sha256 cellar: :any_skip_relocation, monterey:       "8132ad17f4eb1994adac4e7c20f86d4570ab15cb807672dd4a645f4cd07210e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf37432b95e29a157c0bdceb946999e50e1fa45cc4c5c478bf6f2fdf23c10fcc"
    sha256 cellar: :any_skip_relocation, catalina:       "44d7d64e4c11cb1c239a5e8e625d3143a5cf6983831b106619aaa1f8444a7f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acba5572f707fdcfa1697971682d0fc948242a19c55075da292c1c27e115e4ae"
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
