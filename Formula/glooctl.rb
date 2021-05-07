class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.7.5",
      revision: "2bf4a4abd3c3e527fd9e42b508fb9f198d41237e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f74a6d5f5b5f43fd22556e5b8e0431eaca9dd7d2c72492cbb25f120c6c26ceba"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b6454fa4ef0c4636a440e9461930b1822f6ffc38004c86e66b35213475a83ce"
    sha256 cellar: :any_skip_relocation, catalina:      "a759dcbd79dae9296ecd807c59dfb3a59b0c89dc2b84950e09231fefb6636152"
    sha256 cellar: :any_skip_relocation, mojave:        "2d11ee70d1605b1ed6abd6c820a1e1e543fa4d16070447c376eabbebe44a0851"
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
