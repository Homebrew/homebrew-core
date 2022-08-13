class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.5",
      revision: "b0d0516ff077cbff6cfe2fc73eb66f72d7774bcc"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "091b9cbcfbf6af5b409ecf2f964a6598e984e01abc40f156ac2390c371129a71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc3deb52dcfa273b2490226f5cb9438528dfd3ab6c28af2abb19d129f6bfa176"
    sha256 cellar: :any_skip_relocation, monterey:       "f5b1e1aac29e3afaec11353c9918a509c942aff8fdd6bd2476a528366907a768"
    sha256 cellar: :any_skip_relocation, big_sur:        "e506488e573fa2338dc9ca4f4c4efd8f6953f83030497265cfb7ad7e8d2e9cfe"
    sha256 cellar: :any_skip_relocation, catalina:       "881cc7ea999e4a1d224b4d626769b19522eaf2b0570c7ce0d0df66c95fa97dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5a673774f731e6c072b90b51770bc59a3bb9465ab21f3ed96cabf17a37e731e"
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
