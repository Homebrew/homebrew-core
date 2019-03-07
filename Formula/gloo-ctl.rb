class GlooCtl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.8.6",
      :revision => "42a89574813b066fb096b289ebebbe412d9cf5a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "7583ecc0bd66af9e8e0305288a5f8573680ed3b347db18fa767f17605fdf638a" => :mojave
    sha256 "9a5dc061fbfbc831d1b3b34ae2852ba32374b6995680d92d71da949412aae4bf" => :high_sierra
    sha256 "5470c6c8c82fea7cbaa42ba05530d3f216ff1c3d9b760a33a9aba3c9d21ed246" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/gloo"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make", "glooctl", "TAGGED_VERSION=v#{version}", "RELEASE=false"
      bin.install "_output/glooctl"
    end
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl --version 2>&1")
    assert_match "glooctl version #{version}", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create proxy client", status_output
  end
end
