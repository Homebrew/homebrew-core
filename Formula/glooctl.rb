class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.11",
      revision: "09f446650f206c3fba4890fec6a5e39255a13c2f"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc070a3571b88036b1d26336c4da6fff04a6f2ade47343dd9519bccb470a7e08"
    sha256 cellar: :any_skip_relocation, big_sur:       "c04869804774aa3a60c0072dc24652a7f44e403121065782e892b7440f17331f"
    sha256 cellar: :any_skip_relocation, catalina:      "d14cba572901858949a25d2c8f54da768765daaaf4e77388eef37747aa9511a6"
    sha256 cellar: :any_skip_relocation, mojave:        "e9e57b2e317b3e727458706c21bf367650158dcc265808c5f5a7b482c2a30fe5"
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
