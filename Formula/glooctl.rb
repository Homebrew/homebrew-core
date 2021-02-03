class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.7",
      revision: "3574d226c5ae8ceba1decffc4089fd41d8797c69"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "643f59831d5a574a81ebea30f74122810e1059d1fcd83d1d60d90b02d798b377"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a41d441b1391c5e228be254c22f8e123c32b5de031c68af6c431cc4f4a98619"
    sha256 cellar: :any_skip_relocation, catalina:      "03bcda2941a51d3098df14f8fafd5a3fbe4c616aa5892b8143aa892edd6093e3"
    sha256 cellar: :any_skip_relocation, mojave:        "dc34fe497e374cdfa736dd0790f49bcec80ea82a98173541d574ddba086369ac"
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
