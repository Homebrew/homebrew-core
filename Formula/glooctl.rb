class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.21",
      revision: "5789663694a97d66fef4d1ccb52f65be2d3f0bf0"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5355530a576faf98574a3f208bf3c6c1e1a30921ab44683bb4a9d99ac3c3fa04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "087f15fce14c5a506ce0fadef026525dace2b7ea61d41d6802407b96ee4f6438"
    sha256 cellar: :any_skip_relocation, monterey:       "edeb12f0d6b2d80afee8794e2d2cd6039d6787f0989135ba3f3142d0c13d65ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "0de0d650581cc0cf3e27e4fa7ed9d42dbab067bac0f83877caeed7acd609a9d1"
    sha256 cellar: :any_skip_relocation, catalina:       "5a221285158a07a642cb933ebe7d85324ca03a2c4c78125cb193bff0ba15ad57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d5ddcb1b965f3ce0d1effd3709dd2f5c738d275f9a53833ba42ad8cba129d83"
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
