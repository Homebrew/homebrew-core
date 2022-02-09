class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.7",
      revision: "b8a13d44320e9154d0ecd2e9983859833d5a323b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb679406fdb628629f5a9431f94a96e5f7de1affd4fe9ff59b64a68143f745be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5e98eecfd84034efa701fcb8b7ea590fe4cd97d588e33e14554779b9d770ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "45c7705403c7157996913fa928be20a8540edc7eb48eafdb9c750609f59d36b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "346d38bb6b5464eed575700442bb4a5ff75ca1e41238d25352159241c39610eb"
    sha256 cellar: :any_skip_relocation, catalina:       "16471b26c3a696daa53be1e3b82a0dd1518498379ec498f18f59eba95a3b2917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeb40739d8dbf27bcd1e02553a0e8ce9de6bc1971e4c31e56a3a90f43983690f"
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
