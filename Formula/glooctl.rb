class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v1.3.7",
      :revision => "b0f19d368b7921f25a8c02c65d0faeba64bb60a1"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbd419a3a3d87d1b52179a4449519602839f52af18fc1a3f6c32d3b64962fff8" => :catalina
    sha256 "78a4576e1af828686bddf4c5ddea297fec6737d12d0da0365ba7e47b9f6f21bf" => :mojave
    sha256 "076facd99a0dfbaac99d4d35b9cf24b2788d3767962c363ee33d425164a12085" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/gloo"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "glooctl", "TAGGED_VERSION=v#{version}"
      bin.install "_output/glooctl"
    end
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
