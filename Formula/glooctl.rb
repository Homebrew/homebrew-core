class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.9.2",
      revision: "a5c1d816fe4c2259eb28ffd59b7f6e90e9cde132"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e29bb96ca4290e9ec759800007631259a549648f55d04931fe74423bebedeab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94526dfd4cfb7721a3dfc1f8b5faf72349d8c3cbb6127449799aa7947aa06af1"
    sha256 cellar: :any_skip_relocation, monterey:       "0821595e887422f069992a06f2fd34021ee68c9d9d91c84009eeaae57e3425d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f94968bd378e8e560700ea58ddd7eaf776cf676abf07c077df458a25609143d5"
    sha256 cellar: :any_skip_relocation, catalina:       "7b416f8a89ab36781dc1426283e1f6f8068cff115b81425736c3eba84164dae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2540dd9ce04e7e2a0803f6680b859e432a9b86b5c02f33b7234c8dd07a46d7c0"
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
