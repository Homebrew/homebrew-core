class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.8",
      revision: "01cd114ef32a248ca9d1c7c1180a92f080431fdb"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a4317fa12a08f0def62894fd9b7428ae867a6f77f0a91e84c59c9431b31638f"
    sha256 cellar: :any_skip_relocation, big_sur:       "0336790e70fad1d9421326ee9f29041a1ea04c4482ee52dd199f15f1d5052de4"
    sha256 cellar: :any_skip_relocation, catalina:      "97b01fe69de96637a277ff770d66304fbd182dafb3fdd433d7059e143899f81c"
    sha256 cellar: :any_skip_relocation, mojave:        "8ac9086f6c41e3a02984b9431da6d1d3a7b90ecc61eac35ab39ca420dfe1cc2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ebd8c38e66c4961a822e5cdbc420e47e9fa75fbfb9a09187082db9d3e774e7f"
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
