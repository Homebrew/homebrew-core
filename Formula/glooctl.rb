class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.5",
      revision: "f1b134aea13345e03f553e6141abdb7d722d2e3d"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a3b0688e4ef2679da665b6e6d9092d3934ab58018a361c1bced78d522fe3f4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cb043251227577946841c12a63379df5ba119439cad1413c03858ff71e41ea4"
    sha256 cellar: :any_skip_relocation, catalina:      "7cf19758f290afa92b8d2b9347af3731dbcd16777776d6b67c55a05b6d24796e"
    sha256 cellar: :any_skip_relocation, mojave:        "8628889655c8a1c47bec89363ab8c678c969f34fb08107e004faec35f90ad951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8f37fde76b5a4fd04096b104ab4677deee9dd7a1ba1a46a973c8d0b6ace3af1"
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
