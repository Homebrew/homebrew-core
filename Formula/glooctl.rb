class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.1",
      revision: "2a5441ac56a4ae4c16b7b05e0f2fa81ac87ad2c4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5dcbfcb98690ff6a31f15e1a0786ae95bdbe7ede763b92fd8a9fa6e9b0c87c36"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc36ae85d62bb31a8d6e1ef6811545fec19853a1b4066d1d82ce85751a671830"
    sha256 cellar: :any_skip_relocation, catalina:      "93b6411cd5592288c03c5fc807a733b42f080b0939ed8e202fde309728578dfa"
    sha256 cellar: :any_skip_relocation, mojave:        "97f3abd6ffe238c190d3f9580c42fe18c127dabed19fce2b3dbc15be0c8f3719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "604974f7fb109b12e57a8b9494ead8f9c3715f4d0850d7e7babee78417d35548"
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
