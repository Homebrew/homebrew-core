class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.11",
      revision: "6ecf80b83e1d1a5e68aa8496f96f8239d473eb77"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8c1b9f1f2883a883075e7b0d03ed575a581fa2fd5f9afd23a28bbc86b4d853d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a90b441b5e921f81f963e485c9f5507fc5773f46aae7edf7291b4a22fc7dc9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cc1ef45b7c7a1800327b810d041da04a7fdf4f373ea0f5eb9bd3fcb7c906664"
    sha256 cellar: :any_skip_relocation, ventura:        "2c2eed49365e8b2703e4a3174067f243212276fd9a779c86ae2648dfb57437e5"
    sha256 cellar: :any_skip_relocation, monterey:       "db47a360aebe6a8c07bab2aab1af21f676a7f18d6078c3b7a592d4c95f9f3d33"
    sha256 cellar: :any_skip_relocation, big_sur:        "71754ef0f14e71b08d59b37d3848063101fdae29add3f6360070776367841e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a60a5e7112afafe9460c070f2d68ffcbca716caac4542c378dcfcf79b4399b6"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
