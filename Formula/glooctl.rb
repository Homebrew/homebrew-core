class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.5.11",
      revision: "fd499e26fef3928cc8d9be5fc9abcf5268d75ad9"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "499e83be6c4bd4599bbc8f563e4eaed720bfcda00d4a0b87aac4171e714e6e1c" => :big_sur
    sha256 "041fa1aff2f0c14a57e6ba8a9962d2b6c02eaf9246709b3488280a893d53ee12" => :catalina
    sha256 "533e07e83f73652043c8141941b52573874097128847fb7e0848639990192cd5" => :mojave
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
