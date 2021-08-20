class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.9",
      revision: "c55eec54a6452f616538829b527772ff91844ea4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa47af33f3721149e4074e8c3ef7b29ad18ed33f64ef8630734c3c65c009c14e"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc7f7404a3631a4f7ab0ee3af9c829ef875e0ae46dd467ffe04d6a0d8371c722"
    sha256 cellar: :any_skip_relocation, catalina:      "df83d5159b1547c3ccc6d566e393068ac2c712d15daa37ba7a07301432fcbe5b"
    sha256 cellar: :any_skip_relocation, mojave:        "a0a1519397a2e37e2e5c64f9830393ed511c66c6a98c33610945c99bd98c9109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a62fc63934913e0d6df4b416873945a6367c43810c129a130b55ddb5407ce8"
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
