class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.2",
      revision: "d17ecd238a829673f6b115d730f3ae6bd1e85c39"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e80ff5ea6cd63436fb6409258beb1dc367b8bc819c0043839a7dfdedc2c6052e" => :big_sur
    sha256 "3aec4421c59e4affec07aa2806068d2d42071178ec23260642c947428542601f" => :arm64_big_sur
    sha256 "615c1a63878f91baa49b482f1776a916484f8642df42a5fb5e488ad282b0173c" => :catalina
    sha256 "878408a61fc3e1221d16fcb0b2e2cec34918d3c2b6eba9e50bf27e5f55759c6e" => :mojave
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
