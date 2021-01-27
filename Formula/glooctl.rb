class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.6",
      revision: "1ab40d6a49c48c9b67caf7d7f524351062b572a8"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eb6baff1998a118cc634960aaa67a0a169a87054bd8fe25d5d521d26a7cd3ef" => :big_sur
    sha256 "6063493213c47ca72bc01de8da85e55a8f5bc9809cf21dfddba8554a8ec37c7a" => :arm64_big_sur
    sha256 "6c445ce72a2b8879503e9f25ef88b2de5b10b1234cb7309e9e8bf04499181ca6" => :catalina
    sha256 "9987436a2dae0ff1a9c60c17293bc95c2dc6b4668503088cce4428c979fb9426" => :mojave
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
