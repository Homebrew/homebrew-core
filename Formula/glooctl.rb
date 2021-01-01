class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.0",
      revision: "eccd48c849eda6c21fe7bb5c821dae7b82f4be64"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2aa9afc591654577f21204f8ae1d27bcc24a1547839f54f8a7bdc43cec611ba7" => :big_sur
    sha256 "224c1d4edf09b6f7efd7661e62102ab501bd2d9554e93327980b1be360cfa7bc" => :arm64_big_sur
    sha256 "497996a4aa2522aa4778a89c8b892f1fad3170fe7006c52873dec26b311f754e" => :catalina
    sha256 "d3e065ff399ec04691ae8addc110fe2f9e8144d286853349901e18ff342b7016" => :mojave
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
