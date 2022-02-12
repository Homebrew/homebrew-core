class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.8",
      revision: "f8e7fa6860572e29a3324631792ae9aafc755542"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aff528a388ffa1215d6f00d5953cd0a1f1690f346e3a777cd9d19ce271521277"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b4bba0002076761800fd478407dffb385e2fbb3856dbdc0fb259f096a3e0b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "e1cc0d9f6f291e6b0e588beb0688dbf18b925450527b2574a5881aeac430abbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e1a246704d2538eabd09dcc9b1367d0d276e03c4ad60aee51c8c8d53ad73b89"
    sha256 cellar: :any_skip_relocation, catalina:       "3de9054110dc15ccbd1aa091b80bcc88201a368ed914e6db4f9dacae9fe4a553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "665ac9d0d9ac0a5d9e644fba658691aee9be8dbf24bd4b1214e8d45edd615cfc"
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
