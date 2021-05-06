class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.4",
      revision: "246a39b206446aa2de4f131ac886fd861bf870f8"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e84b8f9f11baee936fe5caf63eb0ec52231e10481dd8b9c7f60cb565e59812ec"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4273927b88dcaf5b1deb3673cb767f6badca1cd49d07252395b7b59dec7ca94"
    sha256 cellar: :any_skip_relocation, catalina:      "bb7da5cb35ecd72e7338c661ff79fa09d389e1488cf32c540e23a62f98a6870d"
    sha256 cellar: :any_skip_relocation, mojave:        "0ee5e8fdc84a38ab582d361d1e7cedcc95584e2ec27eeb48be2b8e38591bf0f5"
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
