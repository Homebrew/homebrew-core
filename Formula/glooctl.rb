class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.10",
      revision: "5c93fb31bd572a1cea4a98c48e3b707fb65de984"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7266a7d56abd5147c70e360f6168904b362f685df7bfb057b25a32a3916167bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "ff3f8804dbacf6a867e5e336ed2e8cc29cb2639684190b278a8e913486f6c1f8"
    sha256 cellar: :any_skip_relocation, catalina:      "7bb6d808c10ecb6477c9c041150244d8b52a2706cf7f1ee7eaa3ab2320e1acba"
    sha256 cellar: :any_skip_relocation, mojave:        "3323dbaea7ea9424226614f19a3cfa3a2f645ee66992fcf89a9fe86f9102a2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384800ac1ac8221971d0cb3040e6ca2266c14b6155761701fc8a3f3b380b6c3b"
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
