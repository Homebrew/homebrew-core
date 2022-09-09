class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.15",
      revision: "c70e92da7417065d4fbdbb2a9425387996ad3565"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1595cabeeed6ec5ba85a94565bd54bd59eaf4f084bdefe89493b1f23f82672ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d6c28440b7d96e0ebec09cc7b0775ed7f1f6a2efbfc30d9673ec2cce8b27c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "9e07e6241e73bde7386738432cf65d0fd7b4eb3d11fa66a22989c4f2bc414d39"
    sha256 cellar: :any_skip_relocation, big_sur:        "b61c3001a80ff93527c982539199fea5bb7844a64a7a8d0d9c73afadb01b5649"
    sha256 cellar: :any_skip_relocation, catalina:       "508bcd1f0e216028fdeddeefacf0402192e0ce3db9313804969d16de0aa78dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db346abbccc4a54a389f3b963f4a24b28c30f9fd5fc8396ee1ff9a97f3f93d07"
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
