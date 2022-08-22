class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.8",
      revision: "0fb49a386d926285a92e3e74447c5defcdea4335"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e358b94b7bfb48ca8ce8f47be09e75967ac813c0f9505d485c08e6cdd7420e30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1af76a43c37fa8d321d1ff476f2f128202c1306add6a2d9a6e639762027faa99"
    sha256 cellar: :any_skip_relocation, monterey:       "79fd84de30b8b7c8b4b062c7d54fb03ca3f5dad256b1a7542c0b86f1c98f97e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1573116859763d72cc511b1dfef307ec5621155c56bc44b8765a2ba3b78c59cf"
    sha256 cellar: :any_skip_relocation, catalina:       "d77cbc9bddca4404ece37b5e879b4742cb6926ea34159752bf92a401b6a7c893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecddb94e7976dba7cb15eca980de45e662dfadaf48fb851046cb9d0b5b6d4517"
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
