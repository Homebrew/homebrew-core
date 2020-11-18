class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.5.10",
      revision: "c02c864509af7d95cab44b782ed8a54f032b031b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e09e21a654b35cea7ba4452adde2e5ce3da623ed6e8fdca46f423f950960ebd3" => :big_sur
    sha256 "ceb14848fd5005b6de0ff637dc407c449920922ab03c9fdb96f9f459352470c2" => :catalina
    sha256 "de2bfeb6d6aa56788057dc0ac5efc9caa234acd6b5faa64ef0d1d77e60527fb9" => :mojave
    sha256 "742301546a272f0e878eb722e8a05f36490964bc91929abfdcd9d2ede44af6f3" => :high_sierra
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
