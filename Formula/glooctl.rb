class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.6",
      revision: "fe32be19033b324c20383e8480597e89ef1580c7"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce2ebfdcdde70a1706ebf112fe597ae56dab4a0c6564f3268607e9d75118bd36"
    sha256 cellar: :any_skip_relocation, big_sur:       "df9c5402ea553760e5a26eb725ed65f37218ce25e9a1d57ab824e8ccc996c46c"
    sha256 cellar: :any_skip_relocation, catalina:      "4d136f899055ec588707124a2779668f4f1253874bd38e600b59adc4cbf5fd45"
    sha256 cellar: :any_skip_relocation, mojave:        "4e3dbb00bb70421db030edf7bdabf5abe745c2d662439c2428e8df173ee7240a"
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
