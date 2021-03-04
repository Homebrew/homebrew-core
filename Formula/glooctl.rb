class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.13",
      revision: "033036d55e9aef150ce607d315a176ca0e71b5d3"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "599459698bf1185471f52598737221bda0891677d7f661abb1fafb3fded4c583"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f21c941ef6c33a9a578a3de301a6eae911dfb26b47e8d7f4491ba94eb0b076d"
    sha256 cellar: :any_skip_relocation, catalina:      "1e8412e7c0e5afedbc218cd0658307ab603305dfdabe58587192afb8fc986e08"
    sha256 cellar: :any_skip_relocation, mojave:        "46ed9d86230b6cdee1b7c6df398e109964b263c9300c7f48faeef1b732b3f63b"
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
