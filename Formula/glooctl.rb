class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.16",
      revision: "52b9bb5f148b3e049ad9e968427fac0d4a00ab4c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a3f9a9080684db19bbde721dec48c8874d5692cac38369f3cf54143503dbff7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "55901a4afb99db1cb8fff4b94b1d769be4c5f991cbc40f1e2dcb6b26476994f9"
    sha256 cellar: :any_skip_relocation, catalina:      "2588b85dd355ecb3b6fbb3f684fa90eed35403307d211712b221ea562a233dd9"
    sha256 cellar: :any_skip_relocation, mojave:        "d30f0ffe8ddb0aaf6dbe83fff4c616929fd9dd6cb687c900cec9dbf37551d4cb"
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
