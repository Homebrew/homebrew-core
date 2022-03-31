class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.19",
      revision: "7b0f4481f8e86399cddd6f319ada70d6c857374b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c866d0c723ac247b43b5939cf6cb6d1d42e039f6f17f7c606d575d5b1a528a42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e503afe485ca80e03e47fc19970df7244c37dace5a5f9d615c35fd3b78fba0c2"
    sha256 cellar: :any_skip_relocation, monterey:       "972a9f3a5673db56def89b51970a250542de40578deed0d67604d7e2d9e919a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c68733440c9d9a56e3d1237bb8471faf2e7890db80b9f715964bdd6ea9183243"
    sha256 cellar: :any_skip_relocation, catalina:       "7fabee04aaa28c6e6c763e5aea9206ba515dc8978d16758a2232fe502937499b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709954d2aafd9409bb131f8812bbb45bfdfb6b72421dd4c4c35e0068aa644bdf"
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
