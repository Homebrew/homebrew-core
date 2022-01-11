class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.0",
      revision: "7ab135d3b288d90b37e42c78cd70ac203621e113"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b57d82bd35cf459696c8918c07a37ae85fdabff352ad129712d3f122a0084fc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29033d5a1566f3a44d435f93c76d4ab111566f81b1b35aa36672445337d9c5d2"
    sha256 cellar: :any_skip_relocation, monterey:       "fbbea114352aaf5cdd6e78ad0eb0074d3f13d732a72b7ee4bb35645d39728db2"
    sha256 cellar: :any_skip_relocation, big_sur:        "891105e96fd6a4d0d3bbf036c613df5de521e4cf2a16f67e4da5f7a6dbfcc844"
    sha256 cellar: :any_skip_relocation, catalina:       "b82ea3e2e4ccdbfdbeadbe205082bc20941f83d12866a54096e36cc42659db81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b6db1a61ff6ff98ba9e23bd598e299297166656a7a899a10c8eb2c10aa0fb5c"
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
