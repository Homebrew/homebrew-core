class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.12",
      revision: "c6ffc770e67365bc1f582fdaceee6becc0ab8289"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6225a230b387148b3b6d75382e2436042db1523dfacefd875965dfebdf4b2c09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35fcea62bdd8bb51f0bf1cc6291b3a1ca9e997377ee1ce757f240721abb497a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f5c183fd35ac6e12847c650dc6f9822374c9db40aa82652ae11723ec1ece3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b0cccd6def046a190e33c5faf76fac4d2c35cea2b26064b6f1e097f9786e3b3"
    sha256 cellar: :any_skip_relocation, catalina:       "f552a7a2428774a5de56e879e873d01b77ba34cb66cd0a6ea58e9e5effe72742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeaab9bc158057cc7f20b1cf54e9bdcdddca5876db985cd0bda8e2d26d9918c2"
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
