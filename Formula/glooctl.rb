class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.24",
      revision: "d58a77ea160212b6347652f90c60d518db5b1bcd"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1277e0c8547930064d04d4748e4b7116f698a8cac46cbabffa910f7f56b9782c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "065f4a144f02a96b4dea144459369b0a70a59a56cede74618b009e08ccb5374c"
    sha256 cellar: :any_skip_relocation, monterey:       "8a659d03134b14586fc2dd8886c835caa905b32db5ea958894832daea0d4b521"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd829180b5ff616f4ab2a8ea8ecb1a40bd6449e54063c1ae2ad9efc8842ac75b"
    sha256 cellar: :any_skip_relocation, catalina:       "e1f5bc6e1467fde55a2fe35e57643af5134b69cab149a8eba4875981f5cbee53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4ebe4a42383e5a748f5752316d9dd4a37518ad67235facb1971256db925125"
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
