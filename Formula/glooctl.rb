class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.9.6",
      revision: "a13c11c9bdcc604b954afec1d0f92fba4e97ab2e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a574826d731757ce172789baf3e60daa787617526ee5f3c32a71b3dd07c85c15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59d3ba79cf07c3f21ff6b1abe82b4c0a4c53355c0e71b1633954a52d8b946ca7"
    sha256 cellar: :any_skip_relocation, monterey:       "b0014f4c31a769dd7290950d145334a86df14e68475639d2ca9ede23fbc2e6bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "71716585a79101cb5b12638544210838ebe3349514d214e81eeefc528173d119"
    sha256 cellar: :any_skip_relocation, catalina:       "9b590b7bdeb020a4c06249236e07796f84bff0829dc450f29cdc9307de1f6afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d2f78e77c2dcdc397b4ebaa875040002b95d9deaca12233de5c69d8d77b39b"
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
