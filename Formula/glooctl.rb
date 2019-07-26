class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.18.2",
      :revision => "8a7d8e832c262df2a2f08a6eb4686b499d65871f"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18ca01d0a06021e74121642e66bd38ae4e0a9163413f7d6753b03e3f5c9caf04" => :mojave
    sha256 "c24c03bf2df60a0cc419906b62f95479a32ff2c52191e61399da251fef6a38c9" => :high_sierra
    sha256 "9de26d6790889115b3ac1941ce009d15fdc2d8203933c3c196d4e75740060945" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/gloo"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make", "glooctl", "TAGGED_VERSION=v#{version}"
      bin.install "_output/glooctl"
    end
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl --version 2>&1")
    assert_match "glooctl community edition version #{version}", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create proxy client", status_output
  end
end
